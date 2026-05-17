import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland

PanelWindow {
  id: root

  required property QtObject theme

  visible: false
  focusable: true

  width: 600
  height: 450
  color: "transparent"


  //WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  Process {
    id: screenshotWholeScreen
    command: ["bash", "-c", "sleep 0.5; grim -o " + Hyprland.focusedMonitor?.name + " ~/screenshot.png"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: console.log("grim -o " + Hyprland.focusedMonitor?.name + " ~/screenshot.png")
    }
  }

  Process {
    id: screenshotSelection
    command: ["bash", "-c", "slurp"]
    running: false
    stdout: StdioCollector {
      onStreamFinished: console.log("TESTTTTTTTTT")
    }
  }


  Rectangle {
    id: win
    anchors.fill: parent
    radius: 14
    color: root.theme.bg
    border.width: 1
    border.color: Qt.alpha(root.theme.fg, 0.12)

    Rectangle {
      id: monitorScreenshot
      radius: 14
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.margins: 0
      width: parent.width / 2
      color: root.theme.fg
      border.width: 1
      border.color: Qt.alpha(root.theme.bg, 0.12)
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          root.visible = false
          screenshotWholeScreen.running = false
          screenshotWholeScreen.running = true
        }
        onExited: parent.scale = 1.0
        onPressed: parent.scale = 0.92
        onReleased: parent.scale = 1.0
      }
    }
    Rectangle {
      id: regionScreenshot
      radius: 14
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 0
      width: parent.width / 2
      color: root.theme.fg
      border.width: 1
      border.color: Qt.alpha(root.theme.bg, 0.12)
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          root.visible = false
          screenshotSelection.running = false
          screenshotSelection.running = true
        }
        onExited: parent.scale = 1.0
        onPressed: parent.scale = 0.92
        onReleased: parent.scale = 1.0
      }
    }
  }
}
