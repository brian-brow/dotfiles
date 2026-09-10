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
  required property ShellScreen modelData
  required property QtObject theme

  screen: modelData
  signal cavaHovered(bool hovered)

  anchors.top: true
  // anchors.bottom: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 33

  color: "transparent"

  // Same tokens as rofi and the clipboard manager. The matugen rofi template
  // stamps 7f onto every color except the text roles, and Theme.qml comes out
  // of the same matugen run, so the alpha is applied at use instead of baked
  // in. Hyprland blurs this: conf/rules.lua blurs the `quickshell` namespace.
  readonly property real rofiAlpha: 0x7f / 255

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
    color: Qt.alpha(root.theme.bg, 0.9)
    border.width: 1
    border.color: Qt.alpha(root.theme.secondary_container, root.rofiAlpha)

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

      CavaView {
        id: cava
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        theme: root.theme
        source: cavaSource
        startIndex: 0
        visibleBarCount: 40
        mirror: false
        width: 255
        height: 22

        // onContainsMouseChanged: root.cavaHovered(cava.containsMouse)
        onContainsMouseChanged: root.cavaHovered(containsMouse)
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
