import QtQuick
import Quickshell
import Quickshell.Io
import "."

CircularProgress {
  id: root

  required property QtObject theme

  property bool charging: false
  property int percentage: 0

  signal clicked()

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: Quickshell.execDetached(["/home/brian/.config/rofi/scripts/powerprofiles.sh"])
  }

  value: percentage
  lineWidth: 2
  progressColor: charging ? theme.tertiary : theme.primary
  trackColor: Qt.alpha(theme.primary, 0.25)
  iconColor: charging ? theme.primary
  : percentage <= 20
    ? theme.error
    : theme.fg

  iconPixelSize: 10      // makes glyph bigger/smaller
  iconXOffset: 0        // moves glyph left/right
  iconYOffset: 0        // moves glyph left/right

  icon: percentage


  function refreshPercentage() {
    percentageProc.running = false
    statusProc.running = false

    percentageProc.running = true
    statusProc.running = true
  }

  Process {
    id: percentageProc
    command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity"]

    stdout: SplitParser {
      onRead: data => {
        const n = parseInt(data.trim())
        if (!isNaN(n))
        root.percentage = n
      }
    }
  }

  Process {
    id: statusProc
    command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status"]

    stdout: SplitParser {
      onRead: data => {
        const s = data.trim()
        root.charging = s === "Charging"
      }
    }
  }

  Timer {
    id: percentageRefreshTimer
    interval: 120
    running: true
    repeat: true
    onTriggered: root.refreshPercentage()
  }

  Component.onCompleted: refreshPercentage()
}
