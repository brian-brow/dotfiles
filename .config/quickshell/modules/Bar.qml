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
  anchors.bottom: true
  anchors.left: true
  implicitWidth: 40

  color: "transparent"

  // Same tokens as rofi and the clipboard manager. The matugen rofi template
  // stamps 7f onto every color except the text roles, and Theme.qml comes out
  // of the same matugen run, so the alpha is applied at use instead of baked
  // in. Hyprland blurs this: conf/rules.lua blurs the `quickshell` namespace.
  readonly property real rofiAlpha: 0x7f / 255
  readonly property string orientation: "vertical"

  CavaSource {
    id: cavaSource
    totalBarCount: 40
  }

  Rectangle {
    anchors {
      top: parent.top
      bottom: parent.bottom
      left: parent.left
    }
    width: parent.width
    color: Qt.alpha(root.theme.bg, 0.9)

    ColumnLayout {
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.topMargin: 6
      spacing: 12

      OsButton {
        theme: root.theme
        orientation: root.orientation
      }

      Workspaces {
        theme: root.theme
        orientation: root.orientation
        screenIndex: Quickshell.screens.indexOf(root.screen)
      }

      // Notification {
      //   theme: root.theme
      //   orientation: root.orientation
      //   Layout.alignment: Qt.AlignHCenter
      // }
    }

    CavaClock {
      anchors.centerIn: parent
      width: parent.width
      height: 300
      theme: root.theme
      source: cavaSource
      orientation: root.orientation
    }

    ColumnLayout {
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottomMargin: 6
      spacing: 12
      ExpandableIndicator {
        id: brightnessItem
        valueText: `${brightness.brightness}`

        BrightnessIndicator {
          id: brightness
          anchors.centerIn: parent
          theme: root.theme
        }
      }

      ExpandableIndicator {
        id: volumeItem
        valueText: `${Math.floor(volume.sink.audio.volume * 100)}`

        VolumeIndicator {
          id: volume
          anchors.centerIn: parent
          theme: root.theme
        }
      }

      ExpandableIndicator {
        id: networkItem
        valueText: `${network.connectionName}`
        verticalText: true

        Network {
          id: network
          anchors.centerIn: parent
          theme: root.theme
        }
      }

      ExpandableIndicator {
        id: batteryItem
        valueText: `${battery.percentage}`

        BatteryIndicator {
          id: battery
          anchors.centerIn: parent
          theme: root.theme
        }
      }

      PowerButton {
        theme: root.theme
        orientation: root.orientation
      }
    }

  }
}
