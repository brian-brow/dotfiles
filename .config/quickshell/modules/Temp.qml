import QtQuick
import Quickshell.Io

Rectangle {
  id: root

  required property QtObject theme
  property int temp

  width: 25
  height: 25
  color: temp < 40
  ? Qt.alpha(theme.primary, 0.25)
  : temp < 65
  ? Qt.alpha(theme.primary, 0.5)
  : temp < 80
  ? Qt.alpha(theme.error, 0.45)
  : Qt.alpha(theme.error, 0.75)


  radius: width / 2

  function updateTemp() {
    tempProc.running = true
  }

  Process {
    id: tempProc
    command: ["bash", "-c", "awk '{print int($1 / 1000)}' /sys/class/thermal/thermal_zone5/temp"]

    stdout: SplitParser {
      onRead: data => {
        const t = parseInt(data.trim())
        if (!isNaN(t)) root.temp = t
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: tempProc.running = true
  }

  Text {
    anchors.centerIn: parent
    text: root.temp
    color: theme.fg
    wrapMode: Text.WordWrap
    width: parent.width * 0.8
    horizontalAlignment: Text.AlignHCenter
  }
}
