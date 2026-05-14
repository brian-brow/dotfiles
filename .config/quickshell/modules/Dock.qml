import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

PanelWindow {
  id: root

  required property QtObject theme
  required property var modelData

  readonly property var iconOverrides: ({
    "zen":       "zen-browser",
    "Navigator": "firefox",
    "nemo": "folder"
  })

  function iconForClass(cls) {
    if (iconOverrides[cls]) return iconOverrides[cls]
    if (cls.startsWith("steam_app_")) return cls.replace("steam_app_", "steam_icon_")
    return cls
  }

  readonly property var runningApps: {
    var _ = Hyprland.toplevels.values.map(t => t.lastIpcObject)
    var seen = {}
    var out = []
    for (var t of Hyprland.toplevels.values) {
      var cls = t.lastIpcObject?.class ?? ""
      if (cls && !seen[cls]) {
        seen[cls] = true
        out.push(t)
      }
    }
    return out
  }

  screen: modelData

  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  // Snap to 4px only after the fade-out finishes (220ms > 200ms fade duration)
  // so the resize is invisible. Snap to 78px instantly on hover so content
  // has room to slide into.
  implicitHeight: root.hovered ? 78 : (shrinkTimer.running ? 78 : 4)
  exclusiveZone: 0
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  color: "transparent"

  // Start the shrink delay whenever the mouse leaves
  onHoveredChanged: {
    if (!root.hovered) shrinkTimer.restart()
  }

  Timer {
    id: shrinkTimer
    interval: 220
    repeat: false
  }

  Component.onCompleted: Hyprland.refreshToplevels()

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (["openwindow", "closewindow", "movewindow",
           "activewindow", "windowtitle"].includes(event.name)) {
        Hyprland.refreshToplevels()
      }
    }
  }

  HoverHandler { id: hoverHandler }

  readonly property bool hovered: hoverHandler.hovered
    && Math.abs(hoverHandler.point.position.x - root.width / 2) < (dockRow.width / 2 + 150)

  Rectangle {
    id: dockRow
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 10
    border.width: 1
    border.color: Qt.rgba(theme.fg.r, theme.fg.g, theme.fg.b, 0.60)
    radius: 32
    antialiasing: true
    color: Qt.rgba(theme.surface_container.r, theme.surface_container.g, theme.surface_container.b, 0.88)

    // Size wraps the Row content plus padding
    width: iconRow.width + 36
    height: iconRow.height + 16

    // Slide up from below on hover; fade simultaneously.
    property real slideOffset: root.hovered ? 0 : 40
    opacity: root.hovered ? 1 : 0
    transform: Translate { y: dockRow.slideOffset }

    Behavior on slideOffset { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on opacity     { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    Row {
      id: iconRow
      anchors.centerIn: parent
      spacing: 12

      Repeater {
      model: root.runningApps

      delegate: Item {
        id: appItem

        readonly property string appClass: modelData.lastIpcObject?.class ?? ""

        readonly property bool isActive: appClass !== ""
          && (Hyprland.activeToplevel?.lastIpcObject?.class ?? "") === appClass

        width: 46
        height: 52

        scale: appArea.pressed       ? 0.85
             : appArea.containsMouse ? 1.18
             : 1.0
        z: appArea.containsMouse ? 1 : 0

        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        Image {
          anchors.top: parent.top
          anchors.horizontalCenter: parent.horizontalCenter
          width: parent.width
          height: 46
          source: appClass
            ? Quickshell.iconPath(root.iconForClass(appClass), "application-x-executable")
            : ""
          sourceSize: Qt.size(512, 512)
          fillMode: Image.PreserveAspectFit
          smooth: true
          mipmap: true
        }

        Rectangle {
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          width: isActive ? 6 : 3
          height: 3
          radius: 1.5
          color: isActive
            ? theme.primary
            : Qt.rgba(theme.on_surface.r, theme.on_surface.g, theme.on_surface.b, 0.3)

          Behavior on width { NumberAnimation { duration: 120 } }
          Behavior on color { ColorAnimation  { duration: 150 } }
        }

        MouseArea {
          id: appArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            Hyprland.dispatch("focuswindow address:0x" + modelData.address)
            console.log(Quickshell.iconPath(root.iconForClass(appClass)))
          }
        }
      }
    }
  }
}
}
