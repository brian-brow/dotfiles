import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
  id: root

  required property QtObject theme

  property int brightness: -1

  function iconForState() {
    if (brightness < 33) return "󰃞"
    if (brightness < 66) return "󰃟"
    return "󰃠"
  }

  Process {
    id: brightnessProc
    command: ["bash", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'" ]

    stdout: SplitParser {
      onRead: data => {
        const value = parseInt(data.trim())
        if (isNaN(value)) return

        if (root.brightness >= 0 && value !== root.brightness) {
          root.shouldShowOsd = true
          hideTimer.restart()
        }
        root.brightness = value
      }
    }
  }

  property bool shouldShowOsd: false

  Timer {
    id: refreshTimer
    interval: 120
    running: true
    repeat: true
    onTriggered: {
      brightnessProc.running = false
      brightnessProc.running = true
    }
  }

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

  Component.onCompleted: brightnessProc.running = true

  // The OSD window will be created and destroyed based on shouldShowOsd.
  // PanelWindow.visible could be set instead of using a loader, but using
  // a loader will reduce the memory overhead when the window isn't open.
  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      // Since the panel's screen is unset, it will be picked by the compositor
      // when the window is created. Most compositors pick the current active monitor.

      anchors.bottom: true
      margins.bottom: screen.height / 5
      exclusiveZone: 0

      implicitWidth: 400
      implicitHeight: 50
      color: "transparent"

      // An empty click mask prevents the window from blocking mouse events.
      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: 4
        color: Qt.alpha(root.theme.surface_container, 0.96)

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 15
          }

          spacing: 10

          Text {
            text: root.iconForState()
            color: root.theme.on_surface
            font.family: root.theme.fontFamily
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30
          }

          Rectangle {
            // Stretches to fill all left-over space
            Layout.fillWidth: true

            implicitHeight: 10
            radius: 4
            color: Qt.alpha(root.theme.on_surface, 0.25)

            Rectangle {
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }

              implicitWidth: parent.width * Math.max(0, root.brightness) / 100
              radius: parent.radius
              color: root.theme.primary

              Behavior on implicitWidth {
                NumberAnimation {
                  duration: 150
                  easing.type: Easing.OutCubic
                }
              }
            }
          }
        }
      }
    }
  }
}
