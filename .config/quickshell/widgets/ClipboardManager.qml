import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
  id: root

  required property QtObject theme

  visible: false
  focusable: true
  color: "transparent"

  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/quickshell"
  readonly property string historyPath: root.stateDir + "/clipboard-history.json"
  readonly property string captureScript: Quickshell.shellPath("scripts/clipboard-capture.sh")
  readonly property string actionScript: Quickshell.shellPath("scripts/clipboard-action.sh")

  // Geometry lifted from ~/.config/rofi/config.rasi. Rofi sizes its listview
  // by line count rather than by pixels, so the window height is derived the
  // same way instead of being a magic number.
  readonly property int windowPadding: 20   // mainbox padding
  readonly property int mainboxSpacing: 20  // mainbox spacing
  readonly property int inputPadding: 15    // inputbar padding
  readonly property int inputSpacing: 10    // inputbar spacing
  readonly property int listSpacing: 10     // listview spacing
  readonly property int elementPadding: 8   // element padding
  readonly property int elementSpacing: 15  // element spacing
  readonly property int iconSize: 32        // element-icon size
  readonly property int lines: 8            // listview lines

  readonly property int rowHeight: root.iconSize + root.elementPadding * 2

  implicitWidth: 500
  implicitHeight: root.windowPadding * 2
    + searchBar.height
    + root.mainboxSpacing
    + root.rowHeight * root.lines
    + root.listSpacing * (root.lines - 1)

  // The matugen rofi template stamps 7f onto every color except the two text
  // roles, which stay opaque. Same palette here — Theme.qml comes out of the
  // same matugen run — so the alpha is applied at use instead of baked in.
  // Hyprland blurs it: conf/rules.lua blurs the `quickshell` namespace.
  readonly property real rofiAlpha: 0x7f / 255

  readonly property color colWindow: Qt.alpha(root.theme.on_primary_fixed, root.rofiAlpha)
  readonly property color colBorder: Qt.alpha(root.theme.secondary_container, root.rofiAlpha)
  readonly property color colInput: Qt.alpha(root.theme.on_primary, root.rofiAlpha)
  readonly property color colSelected: Qt.alpha(root.theme.primary, root.rofiAlpha)
  readonly property color colText: root.theme.on_surface
  readonly property color colSelectedText: root.theme.on_secondary
  readonly property string fontFamily: root.theme.fontFamily
  readonly property int fontSize: 10

  // Newest first. An entry is either a plain string (text) or an
  // {image: "<path>"} object.
  property var history: []
  readonly property int historyLimit: 60

  // Like rofi, a row is always highlighted — the top one until the wheel or a
  // click moves it — rather than the highlight tracking the pointer.
  property int selectedIndex: 0

  // Rows never show more than a couple of lines, so never hand a Text element
  // more than this. One multi-megabyte paste otherwise stalls the whole shell.
  // Pasting reads the full entry back from the file, so nothing is lost.
  readonly property int previewLimit: 8192

  // The rows actually on screen. Each carries its own history index, because
  // once the list is filtered a row's position no longer matches the index the
  // action script reads back.
  readonly property var filtered: {
    var query = searchEntry.text.trim().toLowerCase()
    var rows = []
    for (var i = 0; i < root.history.length; i++) {
      if (query && root.searchText(root.history[i]).toLowerCase().indexOf(query) < 0) continue
      rows.push({ entry: root.history[i], historyIndex: i })
    }
    return rows
  }

  function imagePath(value) {
    return (value && typeof value === "object" && value.image) ? String(value.image) : ""
  }

  function fileUrl(path) {
    return "file://" + String(path).split("/").map(encodeURIComponent).join("/")
  }

  function entryKey(value) {
    var image = root.imagePath(value)
    return image ? "image:" + image : "text:" + String(value)
  }

  function validEntry(value) {
    if (typeof value === "string") return value.trim().length > 0
    return root.imagePath(value) !== ""
  }

  function preview(text) {
    var value = String(text)
    if (value.length > root.previewLimit) value = value.slice(0, root.previewLimit)
    return value.replace(/\s+/g, " ").trim()
  }

  // Searches the same capped preview the row renders, so one huge paste can't
  // turn every keystroke into megabytes of string scanning.
  function searchText(value) {
    return root.imagePath(value) ? "image" : root.preview(value)
  }

  function activateSelected() {
    if (root.selectedIndex < 0 || root.selectedIndex >= root.filtered.length) return
    root.paste(root.filtered[root.selectedIndex].historyIndex)
  }

  // A physical wheel notch is 120 units, but high-resolution wheels report it
  // as a burst of smaller steps. Accumulate and move one row per notch, or the
  // selection flies off on a single flick.
  readonly property int wheelNotch: 120
  property int wheelAccum: 0

  function scrollSelection(wheel) {
    var delta = wheel.angleDelta.y
    if (delta === 0) return

    // Reversing direction shouldn't have to burn off the old residue first.
    if ((root.wheelAccum > 0) !== (delta > 0)) root.wheelAccum = 0
    root.wheelAccum += delta

    while (root.wheelAccum >= root.wheelNotch) {
      root.wheelAccum -= root.wheelNotch
      root.moveSelection(-1)
    }
    while (root.wheelAccum <= -root.wheelNotch) {
      root.wheelAccum += root.wheelNotch
      root.moveSelection(1)
    }
  }

  // rofi's listview sets `cycle: true`, so running off either end wraps.
  function moveSelection(delta) {
    var count = root.filtered.length
    if (count === 0) return
    root.selectedIndex = (root.selectedIndex + delta + count) % count
    resultList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
  }

  // Any change to what is on screen — a keystroke in the search box, or a new
  // copy landing while the picker is open — puts the highlight back on top.
  onFilteredChanged: {
    root.selectedIndex = 0
    resultList.positionViewAtBeginning()
  }

  function save(next) {
    root.history = next
    historyFile.setText(JSON.stringify(next) + "\n")
  }

  function addEntry(value) {
    if (!root.validEntry(value)) return

    var key = root.entryKey(value)
    var next = [value]
    for (var i = 0; i < root.history.length && next.length < root.historyLimit; i++)
      if (root.entryKey(root.history[i]) !== key) next.push(root.history[i])

    root.save(next)
  }

  function addJson(line) {
    var raw = String(line || "").trim()
    if (!raw) return
    try { root.addEntry(JSON.parse(raw)) } catch (e) {}
  }

  function loadHistory(raw) {
    try {
      var parsed = JSON.parse(String(raw || "[]"))
      root.history = Array.isArray(parsed) ? parsed.filter(root.validEntry) : []
    } catch (e) {
      root.history = []
    }
  }

  function paste(historyIndex) {
    if (historyIndex < 0 || historyIndex >= root.history.length) return
    root.visible = false
    Quickshell.execDetached([root.actionScript, String(historyIndex)])
  }

  function remove(historyIndex) {
    if (historyIndex < 0 || historyIndex >= root.history.length) return
    var next = root.history.slice()
    next.splice(historyIndex, 1)
    root.save(next)
  }

  onVisibleChanged: {
    focusGrab.active = root.visible
    if (root.visible) {
      resultList.positionViewAtBeginning()
      searchEntry.forceActiveFocus()
    } else {
      // Reset on close rather than on open. Clearing an already-empty search
      // box emits no change signal, so onFilteredChanged would not run and a
      // highlight left partway down the list would survive into the next open.
      searchEntry.text = ""
      root.selectedIndex = 0
      root.wheelAccum = 0
    }
  }

  Component.onCompleted: initProc.running = true

  HyprlandFocusGrab {
    id: focusGrab
    windows: [root]
    onCleared: root.visible = false
  }

  FileView {
    id: historyFile
    path: root.historyPath
    watchChanges: true
    atomicWrites: true
    printErrors: false
    onLoaded: root.loadHistory(text())
    onLoadFailed: root.loadHistory("[]")
    onFileChanged: reload()
  }

  // Reap watchers left behind by a previous shell instance, then start our
  // own. The pdeathsig makes the kernel kill them whenever the shell exits,
  // however it exits, so there is no further lifecycle management. The mkdir
  // goes first so the very first capture has somewhere to land.
  Process {
    id: initProc
    command: ["bash", "-c",
      "mkdir -p " + JSON.stringify(root.stateDir) + "; "
      + "pkill -f 'wl-paste .*--watch .*/clipboard-capture\\.sh'; true"]
    onExited: {
      currentProc.running = true
      textWatchProc.running = true
      imageWatchProc.running = true
    }
  }

  Process {
    id: currentProc
    command: [root.captureScript]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.addJson(text)
    }
  }

  Process {
    id: textWatchProc
    command: ["setpriv", "--pdeathsig", "TERM", "wl-paste", "--type", "text", "--watch", root.captureScript, "text"]
    onExited: watchRestartTimer.restart()
    stdout: SplitParser {
      onRead: function(data) { root.addJson(data) }
    }
  }

  Process {
    id: imageWatchProc
    command: ["setpriv", "--pdeathsig", "TERM", "wl-paste", "--type", "image/png", "--watch", root.captureScript, "image/png"]
    onExited: watchRestartTimer.restart()
    stdout: SplitParser {
      onRead: function(data) { root.addJson(data) }
    }
  }

  // A watcher that dies takes clipboard history with it, silently: copying
  // still works, the picker still opens, and the old entries are all still
  // there, so nothing is recorded until the next shell reload. Bring it back.
  Timer {
    id: watchRestartTimer
    interval: 1000
    repeat: false
    onTriggered: {
      if (!textWatchProc.running) textWatchProc.running = true
      if (!imageWatchProc.running) imageWatchProc.running = true
    }
  }

  // rofi `window`
  Rectangle {
    id: card
    anchors.fill: parent
    radius: 15
    color: root.colWindow
    border.width: 2
    border.color: root.colBorder

    // Catches the wheel over the padding and the search bar. Declared before
    // the ListView so the rows sit above it and get first crack at their own
    // area; NoButton keeps clicks falling through to whatever is underneath.
    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.NoButton
      onWheel: function(wheel) { root.scrollSelection(wheel) }
    }

    // rofi `inputbar`
    Rectangle {
      id: searchBar
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.topMargin: root.windowPadding
      anchors.leftMargin: root.windowPadding
      anchors.rightMargin: root.windowPadding
      height: searchEntry.implicitHeight
      radius: 10
      color: root.colInput

      // rofi `textbox-prompt-colon` — its str is two literal spaces, so this
      // is an indent rather than an icon.
      Text {
        id: searchPrompt
        anchors.left: parent.left
        anchors.leftMargin: root.inputPadding
        anchors.verticalCenter: parent.verticalCenter
        text: "  "
        color: root.colText
        font.family: root.fontFamily
        font.pointSize: root.fontSize
      }

      // rofi `entry`
      TextField {
        id: searchEntry
        anchors.left: searchPrompt.right
        anchors.leftMargin: root.inputSpacing
        anchors.right: parent.right
        anchors.rightMargin: root.inputPadding
        anchors.verticalCenter: parent.verticalCenter
        topPadding: root.inputPadding
        bottomPadding: root.inputPadding
        leftPadding: 0
        rightPadding: 0
        placeholderText: "Search"
        placeholderTextColor: root.colText
        color: root.colText
        font.family: root.fontFamily
        font.pointSize: root.fontSize
        background: null
        selectByMouse: true
        selectionColor: root.colSelected
        selectedTextColor: root.colSelectedText

        Keys.onEscapePressed: root.visible = false
        Keys.onReturnPressed: root.activateSelected()
        Keys.onEnterPressed: root.activateSelected()
      }
    }

    // rofi `listview` — transparent, sits directly on the window background
    ListView {
      id: resultList
      anchors.top: searchBar.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.topMargin: root.mainboxSpacing
      anchors.leftMargin: root.windowPadding
      anchors.rightMargin: root.windowPadding
      anchors.bottomMargin: root.windowPadding
      model: root.filtered
      clip: true
      spacing: root.listSpacing
      boundsBehavior: Flickable.StopAtBounds
      // rofi has no free scrolling: the wheel walks the highlight, and the
      // view follows it.
      interactive: false

      // rofi `element` / `element selected.normal`
      delegate: Rectangle {
        id: row

        required property int index
        required property var modelData

        readonly property var entry: row.modelData.entry
        readonly property int historyIndex: row.modelData.historyIndex
        readonly property string imagePath: root.imagePath(row.entry)
        readonly property bool selected: row.index === root.selectedIndex

        width: ListView.view.width
        height: root.rowHeight
        radius: 10
        clip: true
        color: row.selected ? root.colSelected : "transparent"

        Row {
          anchors.fill: parent
          anchors.margins: root.elementPadding
          spacing: row.imagePath ? root.elementSpacing : 0

          // rofi `element-icon`
          // PreserveAspectFit scales to fit *inside* these bounds, so the
          // thumbnail can never paint outside its box however big the source
          // is. sourceSize caps what actually gets decoded.
          Image {
            width: row.imagePath ? root.iconSize : 0
            height: parent.height
            visible: row.imagePath !== ""
            source: row.imagePath ? root.fileUrl(row.imagePath) : ""
            fillMode: Image.PreserveAspectFit
            sourceSize.width: root.iconSize * 2
            sourceSize.height: root.iconSize * 2
            asynchronous: true
            smooth: true
          }

          // rofi `element-text`
          Text {
            width: parent.width - (row.imagePath ? root.iconSize + parent.spacing : 0)
            height: parent.height
            text: row.imagePath ? "Image" : root.preview(row.entry)
            color: row.selected ? root.colSelectedText : root.colText
            font.family: root.fontFamily
            font.pointSize: root.fontSize
            // Clipboard content is never markup. AutoText would sniff a copied
            // HTML fragment and render it as rich text — <img> tags and all,
            // at natural size, straight over the rest of the list.
            textFormat: Text.PlainText
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
          }
        }

        MouseArea {
          id: rowMouse
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onWheel: function(wheel) { root.scrollSelection(wheel) }
          onClicked: function(mouse) {
            root.selectedIndex = row.index
            if (mouse.button === Qt.RightButton) root.remove(row.historyIndex)
            else root.paste(row.historyIndex)
          }
        }
      }
    }

    Text {
      anchors.centerIn: resultList
      visible: root.filtered.length === 0
      text: root.history.length === 0 ? "Clipboard is empty" : "No matches"
      color: root.colText
      opacity: 0.6
      font.family: root.fontFamily
      font.pointSize: root.fontSize
    }
  }
}
