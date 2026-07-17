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

  iconXOffset: -2       // moves glyph left/right
  iconYOffset: -1        // moves glyph left/right

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
  Process {
    id: brightnessSetProc
  }

  Timer {
    id: brightnessRefreshTimer
    interval: 120
    running: true
    repeat: true
    onTriggered: root.refreshBrightness()
  }

  Component.onCompleted: refreshBrightness()

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      const step = 5
      const dir = wheel.angleDelta.y > 0 ? "+" : "-"
      brightnessSetProc.command = ["bash", "-c", `brightnessctl set ${step}%${dir}`]
      brightnessSetProc.running = false
      brightnessSetProc.running = true
      root.refreshBrightness()
    }
  }
}
