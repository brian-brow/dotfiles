import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
  id: root

  required property QtObject theme

  function iconName() {
    const sink = Pipewire.defaultAudioSink
    if (!sink || sink.audio.muted) return "audio-volume-muted-symbolic"
    if (sink.audio.volume < 0.33) return "audio-volume-low-symbolic"
    if (sink.audio.volume < 0.66) return "audio-volume-medium-symbolic"
    return "audio-volume-high-symbolic"
  }

  // Bind the pipewire node so its volume will be tracked
  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }
  }

  property bool shouldShowOsd: false

  Timer {
    id: hideTimer
    interval: 1000
    onTriggered: root.shouldShowOsd = false
  }

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

          IconImage {
            source: Quickshell.iconPath(root.iconName(), "audio-volume-high-symbolic")
            opacity: 1.0

            Layout.preferredWidth: 30
            Layout.preferredHeight: 30

            layer.enabled: true
            layer.effect: ColorOverlay {
              color: root.theme.on_surface
            }
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

              implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
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
