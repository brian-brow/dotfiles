import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  HoverHandler { id: hover }

  required property QtObject theme

  property string icon: "󰂚"
  property int iconPixelSize: hover.hovered ? 20 : 18

  Behavior on iconPixelSize {
    NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
  }

  width: 28
  height: 28

  function updateFromJson(data) {
    try {
      const obj = JSON.parse(data.trim())

      const cls = obj.class || ""
      const classes = Array.isArray(cls) ? cls : [cls]

      const has = name => classes.indexOf(name) !== -1

      if (has("dnd-inhibited-none") || has("inhibited-none"))
      root.icon = "󰂛"
      else if (has("dnd-inhibited-notification") || has("inhibited-notification"))
      root.icon = "󰂛"
      else if (has("dnd-notification"))
      root.icon = "󰅸"
      else if (has("dnd-none"))
      root.icon = "󰂜"
      else if (has("notification"))
      root.icon = "󱅫"
      else
      root.icon = "󰂚"
    } catch (e) {
      root.icon = "󰂚"
    }
  }

  function refreshNotificationState() {
    statusProc.running = false
    statusProc.running = true
  }

  Rectangle {
    anchors.centerIn: parent
    width: 28
    height: 28
    radius: 8
    color: mouse.containsMouse
      ? Qt.alpha(root.theme.primary, 0.12)
      : "transparent"

    Behavior on color { ColorAnimation { duration: 120 } }

    Text {
      anchors.centerIn: parent
      text: root.icon
      color: theme.tertiary
      font.pixelSize: root.iconPixelSize
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
  }

  scale: mouse.pressed ? 0.88 : 1.0
  Behavior on scale {
    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: event => {
      if (event.button === Qt.LeftButton) {
        toggleProc.running = false
        toggleProc.running = true
      } else if (event.button === Qt.RightButton) {
        dndProc.running = false
        dndProc.running = true
      }

      refreshDelay.restart()
    }
  }

  Process {
    id: statusProc
    command: ["bash", "-c", "command -v swaync-client >/dev/null 2>&1 && swaync-client -swb"]

    stdout: SplitParser {
      onRead: data => root.updateFromJson(data)
    }
  }

  Process {
    id: toggleProc
    command: ["bash", "-c", "swaync-client -t -sw"]
  }

  Process {
    id: dndProc
    command: ["bash", "-c", "swaync-client -d -sw"]
  }

  Timer {
    id: pollTimer
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.refreshNotificationState()
  }

  Timer {
    id: refreshDelay
    interval: 150
    repeat: false
    onTriggered: root.refreshNotificationState()
  }

  Component.onCompleted: refreshNotificationState()
}
