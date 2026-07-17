import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
  id: root

  required property QtObject theme

  property string selectedProfile: "balanced"
  property int highlightedIndex: 0

  readonly property var profiles: [
    { key: "performance", label: "Performance" },
    { key: "balanced", label: "Balanced" },
    { key: "power-saver", label: "Power Saver" }
  ]

  function syncHighlightFromSelected() {
    const idx = root.profiles.findIndex(p => p.key === root.selectedProfile)
    root.highlightedIndex = idx >= 0 ? idx : 0
  }

  function applyProfile(key) {
    root.selectedProfile = key
    setProfileProc.running = false
    setProfileProc.command = ["powerprofilesctl", "set", key]
    setProfileProc.running = true
  }

  function confirmHighlighted() {
    root.applyProfile(root.profiles[root.highlightedIndex].key)
    root.visible = false
  }

  function refreshProfile() {
    getProfileProc.running = false
    getProfileProc.running = true
  }

  visible: false
  focusable: true

  width: 240
  height: 180
  color: "transparent"

  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  HyprlandFocusGrab {
    id: focusGrab
    windows: [root]
    onCleared: root.visible = false
  }

  onVisibleChanged: {
    focusGrab.active = visible
    if (visible) {
      root.syncHighlightFromSelected()
      root.refreshProfile()
      card.forceActiveFocus()
    }
  }

  Process {
    id: getProfileProc
    command: ["powerprofilesctl", "get"]

    stdout: StdioCollector {
      onStreamFinished: {
        const profile = this.text.trim()
        if (profile.length > 0) {
          root.selectedProfile = profile
          root.syncHighlightFromSelected()
        }
      }
    }
  }

  Process {
    id: setProfileProc

    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text.trim().length > 0)
          console.log("powerprofilesctl set stderr:", this.text)
      }
    }
  }

  Rectangle {
    id: card
    anchors.fill: parent
    radius: 14
    color: root.theme.bg
    border.width: 1
    border.color: Qt.alpha(root.theme.fg, 0.12)

    focus: true

    Keys.onEscapePressed: root.visible = false
    Keys.onPressed: event => {
      switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_Down:
        root.highlightedIndex = Math.min(root.highlightedIndex + 1, root.profiles.length - 1)
        event.accepted = true
        break
      case Qt.Key_K:
      case Qt.Key_Up:
        root.highlightedIndex = Math.max(root.highlightedIndex - 1, 0)
        event.accepted = true
        break
      case Qt.Key_Return:
      case Qt.Key_Enter:
      case Qt.Key_Space:
        root.confirmHighlighted()
        event.accepted = true
        break
      }
    }

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 12
      spacing: 8

      Repeater {
        model: root.profiles

        delegate: Rectangle {
          id: row
          required property var modelData
          required property int index

          property bool isHighlighted: root.highlightedIndex === index

          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 10
          color: root.selectedProfile === modelData.key
            ? Qt.alpha(root.theme.primary, 0.22)
            : isHighlighted || rowMouse.containsMouse
              ? Qt.alpha(root.theme.fg, 0.08)
              : Qt.alpha(root.theme.fg, 0.04)
          border.width: 1
          border.color: root.selectedProfile === modelData.key
            ? Qt.alpha(root.theme.primary, 0.4)
            : isHighlighted
              ? Qt.alpha(root.theme.fg, 0.25)
              : Qt.alpha(root.theme.fg, 0.08)

          Behavior on color {
            ColorAnimation { duration: 120 }
          }

          Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16
            text: modelData.label
            color: root.selectedProfile === modelData.key ? root.theme.primary : root.theme.fg
            font.pixelSize: 14
            font.bold: root.selectedProfile === modelData.key
          }

          MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: root.highlightedIndex = row.index
            onClicked: {
              root.highlightedIndex = row.index
              root.confirmHighlighted()
            }
          }
        }
      }
    }
  }
}
