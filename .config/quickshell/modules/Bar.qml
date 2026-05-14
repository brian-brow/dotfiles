import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick.Window 2.2
import "."

PanelWindow {
  id: root
  required property QtObject theme
  required property var modelData

  screen: modelData

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 33

  color: "transparent"

  CavaSource {
    id: cavaSource
    totalBarCount: 40
  }

  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: 1
    anchors.leftMargin: 1
    anchors.rightMargin: 1
    height: 32
    radius: 10
    color: Qt.rgba(theme.bg.r, theme.bg.g, theme.bg.b, 0.88)
    border.width: 1
    border.color: Qt.rgba(theme.fg.r, theme.fg.g, theme.fg.b, 0.08)

    Item {
      anchors.fill: parent

      RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        OsButton { theme: root.theme }
        Workspaces {
          theme: root.theme
          screenIndex: Quickshell.screens.indexOf(root.screen)
        }
      }

      RowLayout {
        anchors.centerIn: parent
        spacing: 12

        CavaView {
          theme: root.theme
          source: cavaSource
          startIndex: 0
          visibleBarCount: 40
          mirror: false
          width: 80
          height: 22
        }
      }

      RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        // CPU { theme: root.theme }
        Memory {
          theme: root.theme
          // visible: Quickshell.screens.indexOf(root.screen) === 0
        }
        // Temp { theme: root.theme }
        // BrightnessIndicator { theme: root.theme }
        VolumeIndicator { theme: root.theme }
        Network { theme: root.theme }
        // BatteryIndicator { theme: root.theme }
        Clock { theme: root.theme }
        Notification { theme: root.theme }
        PowerButton { theme: root.theme }
      }
    }
  }
}
