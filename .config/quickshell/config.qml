import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: root

  // Theme
  property color colBg: "#1a1110"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colTertiary: "#dfc38c"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 16

  // System data
  property int cpuUsage: 0
  property int memUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  // Processes and timers here...

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 30
  color: root.colBg

  RowLayout {
    anchors.fill: parent
    anchors.margins: 0
    spacing: 10

    // Rofi menu
    Rectangle {
      id: osButton

      height: 22
      width: label.width + 16   // padding-left + padding-right
      radius: 100               // pill shape
      color: mouse.containsMouse
        ? root.colTertiary
        : root.colBlue

      Layout.leftMargin: 4
      Layout.topMargin: 4
      Layout.bottomMargin: 4

      Text {
          id: label
          anchors.centerIn: parent
          anchors.horizontalCenterOffset: -2  // approximates 8px vs 12px padding
          text: ""   // arch icon example

          color: root.colBg

          font {
              family: root.fontFamily
              pixelSize: 16   // ~1.2rem equivalent
              bold: true
          }
      }

      MouseArea {
          id: mouse
          anchors.fill: parent
          hoverEnabled: true
          onClicked: scriptProc.running = true
      }

      Process {
          id: scriptProc
          command: ["bash", "-c", "pgrep rofi >/dev/null 2>&1 && killall rofi || rofi -show drun"]
      }
    }

    // Workspaces
    RowLayout {
      id: workspaceRow
      spacing: 12

      Repeater {
        model: 5
        Text {
          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
          text: ""
          color: isActive
            ? root.colTertiary
            : mouse.containsMouse
              ? Qt.lighter(root.colTertiary, 1.3)
              : (ws ? root.colBlue : root.colMuted)

          font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }

          Behavior on color {
            ColorAnimation { duration: 180 }
          }

          Behavior on scale {
            NumberAnimation {
              duration: 180
              easing.type: Easing.OutCubic
            }
          }
          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Hyprland.dispatch("workspace " + (index + 1))
          }
        }
      }
    }

    Item { Layout.fillWidth: true }

    // CPU
    Text {
      text: "CPU: " + cpuUsage + "%"
      color: root.colYellow
      font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    }

    Rectangle { width: 1; height: 16; color: root.colMuted }

    // Memory
    Text {
      text: "Mem: " + memUsage + "%"
      color: root.colTertiary
      font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
    }

    Rectangle { width: 1; height: 16; color: root.colMuted }

    // Clock
    Text {
      id: clock
      color: root.colBlue
      font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
      text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
      }
    }
  }
}
