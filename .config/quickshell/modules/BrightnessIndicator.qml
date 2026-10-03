import QtQuick
import Quickshell
import Quickshell.Io
import "."

Item {
  id: root

  required property QtObject theme

  property int brightness: 0

  implicitWidth: 24
  implicitHeight: 24

  // value: brightness
  // lineWidth: 2
  // progressColor: theme.primary
  // trackColor: Qt.alpha(theme.primary, 0.25)
  // iconColor: theme.fg
  // icon: brightness < 33 ? "󰃞"
  // : brightness < 66 ? "󰃟"
  // : "󰃠"
  //
  function refreshBrightness() {
    brightnessProc.running = false
    brightnessProc.running = true
  }

  function iconForState() {
    if (brightness < 33) return "󰃞"
    if (brightness < 66) return "󰃟"
    return "󰃠"
  }

  Text {
    anchors.centerIn: parent
    text: root.iconForState()
    color: theme.tertiary
    font.family: theme.fontFamily
    font.pixelSize: 24
    font.bold: true
  }

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      Quickshell.execDetached(["brightnessctl", "set", wheel.angleDelta.y > 0 ? "1%+" : "1%-"])
    }
  }

  Process {
    id: brightnessControl
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
