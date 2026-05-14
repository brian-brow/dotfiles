import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
  id: root

  required property QtObject theme

  implicitWidth: 104
  implicitHeight: 26
  clip: true

  property var coreUsage: []

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: cpuProc.running = true
  }

  Process {
    id: cpuProc
    command: [
      "bash",
      "-c",
      `
awk '
NR==FNR && /^cpu[0-9]+/ {
  prev_idle[$1] = $5 + $6
  prev_total[$1] = $2 + $3 + $4 + $5 + $6 + $7 + $8
  next
}

/^cpu[0-9]+/ {
  idle = $5 + $6
  total = $2 + $3 + $4 + $5 + $6 + $7 + $8

  diff_idle = idle - prev_idle[$1]
  diff_total = total - prev_total[$1]

  usage = (diff_total > 0) ? int(100 * (diff_total - diff_idle) / diff_total) : 0
  printf "%s ", usage
}
END {
  printf "\\n"
}
' /proc/stat <(sleep 1; cat /proc/stat)
      `
    ]

    stdout: SplitParser {
      onRead: data => {
        const text = data.trim()
        if (!text)
          return

        root.coreUsage = text
          .split(/\s+/)
          .map(v => parseInt(v, 10))
          .filter(v => !isNaN(v))
        }
      }
  }

  Row {
    anchors.fill: parent
    spacing: 2

    Repeater {
      model: root.coreUsage.length

      Rectangle {
        required property int index

        width: Math.max(2, (root.width - ((root.coreUsage.length - 1) * parent.spacing)) / Math.max(1, root.coreUsage.length))
        height: Math.max(1, (root.coreUsage[index] / 100) * root.height)
        radius: width / 2

        y: root.height - height
        color: root.theme.fg

        Behavior on height {
          NumberAnimation {
            duration: 180
          }
        }

        Behavior on y {
          NumberAnimation {
            duration: 180
          }
        }
      }
    }
  }
}
