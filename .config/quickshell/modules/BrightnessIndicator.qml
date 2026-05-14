import QtQuick
import Quickshell
import Quickshell.Io
import "."

CircularProgress {
  id: root

  required property QtObject theme

  property int brightness: 0

  value: brightness
  lineWidth: 2
  progressColor: theme.primary
  trackColor: Qt.alpha(theme.primary, 0.25)
  iconColor: theme.fg
  icon: brightness < 33 ? "󰃞"
  : brightness < 66 ? "󰃟"
  : "󰃠"

  function refreshBrightness() {
    brightnessProc.running = false
    brightnessProc.running = true
  }


  Process {
    id: brightnessProc
    command: ["bash", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]

    stdout: SplitParser {
      onRead: data => {
        const n = parseInt(data.trim())
        if (!isNaN(n))
        root.brightness = n
      }
    }
  }

  Timer {
    id: brightnessRefreshTimer
    interval: 120
    running: true
    repeat: true
    onTriggered: root.refreshBrightness()
  }

  Component.onCompleted: refreshBrightness()
}
