import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Io

Item {
  id: root

  required property QtObject theme

  implicitWidth: 104
  implicitHeight: 26
  clip: true

  property real val: 0
  property var history: Array(30).fill(0)

  function yForValue(v) {
    return root.height - (v / 100) * root.height
  }

  function xForIndex(i) {
    if (history.length <= 1)
      return 0
    return i * (root.width / (history.length - 1))
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: memoryProc.running = true
  }

  Process {
    id: memoryProc
    command: ["bash", "-c", "awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf \"%.1f\\n\", (t-a)/t * 100}' /proc/meminfo"]

    stdout: SplitParser {
      onRead: data => {
        const n = parseFloat(data.trim())
        if (!isNaN(n)) {
          root.val = n

          let newArr = root.history.slice()
          newArr.push(n)

          if (newArr.length > 30)
            newArr.shift()

          root.history = newArr
        }
      }
    }
  }

  Shape {
    anchors.fill: parent
    antialiasing: true

    ShapePath {
      strokeWidth: 0
      fillColor: Qt.alpha(root.theme.primary, 0.18)

      startX: 0
      startY: root.height

      PathLine { x: root.xForIndex(0);  y: root.yForValue(root.history[0]) }
      PathLine { x: root.xForIndex(1);  y: root.yForValue(root.history[1]) }
      PathLine { x: root.xForIndex(2);  y: root.yForValue(root.history[2]) }
      PathLine { x: root.xForIndex(3);  y: root.yForValue(root.history[3]) }
      PathLine { x: root.xForIndex(4);  y: root.yForValue(root.history[4]) }
      PathLine { x: root.xForIndex(5);  y: root.yForValue(root.history[5]) }
      PathLine { x: root.xForIndex(6);  y: root.yForValue(root.history[6]) }
      PathLine { x: root.xForIndex(7);  y: root.yForValue(root.history[7]) }
      PathLine { x: root.xForIndex(8);  y: root.yForValue(root.history[8]) }
      PathLine { x: root.xForIndex(9);  y: root.yForValue(root.history[9]) }
      PathLine { x: root.xForIndex(10); y: root.yForValue(root.history[10]) }
      PathLine { x: root.xForIndex(11); y: root.yForValue(root.history[11]) }
      PathLine { x: root.xForIndex(12); y: root.yForValue(root.history[12]) }
      PathLine { x: root.xForIndex(13); y: root.yForValue(root.history[13]) }
      PathLine { x: root.xForIndex(14); y: root.yForValue(root.history[14]) }
      PathLine { x: root.xForIndex(15); y: root.yForValue(root.history[15]) }
      PathLine { x: root.xForIndex(16); y: root.yForValue(root.history[16]) }
      PathLine { x: root.xForIndex(17); y: root.yForValue(root.history[17]) }
      PathLine { x: root.xForIndex(18); y: root.yForValue(root.history[18]) }
      PathLine { x: root.xForIndex(19); y: root.yForValue(root.history[19]) }
      PathLine { x: root.xForIndex(20); y: root.yForValue(root.history[20]) }
      PathLine { x: root.xForIndex(21); y: root.yForValue(root.history[21]) }
      PathLine { x: root.xForIndex(22); y: root.yForValue(root.history[22]) }
      PathLine { x: root.xForIndex(23); y: root.yForValue(root.history[23]) }
      PathLine { x: root.xForIndex(24); y: root.yForValue(root.history[24]) }
      PathLine { x: root.xForIndex(25); y: root.yForValue(root.history[25]) }
      PathLine { x: root.xForIndex(26); y: root.yForValue(root.history[26]) }
      PathLine { x: root.xForIndex(27); y: root.yForValue(root.history[27]) }
      PathLine { x: root.xForIndex(28); y: root.yForValue(root.history[28]) }
      PathLine { x: root.xForIndex(29); y: root.yForValue(root.history[29]) }

      PathLine { x: root.width; y: root.height }
      PathLine { x: 0; y: root.height }
    }
  }

  Shape {
    anchors.fill: parent
    antialiasing: true

    ShapePath {
      strokeWidth: 5
      strokeColor: Qt.alpha(root.theme.primary, 0.18)
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin

      startX: root.xForIndex(0)
      startY: root.yForValue(root.history[0])

      PathLine { x: root.xForIndex(1);  y: root.yForValue(root.history[1]) }
      PathLine { x: root.xForIndex(2);  y: root.yForValue(root.history[2]) }
      PathLine { x: root.xForIndex(3);  y: root.yForValue(root.history[3]) }
      PathLine { x: root.xForIndex(4);  y: root.yForValue(root.history[4]) }
      PathLine { x: root.xForIndex(5);  y: root.yForValue(root.history[5]) }
      PathLine { x: root.xForIndex(6);  y: root.yForValue(root.history[6]) }
      PathLine { x: root.xForIndex(7);  y: root.yForValue(root.history[7]) }
      PathLine { x: root.xForIndex(8);  y: root.yForValue(root.history[8]) }
      PathLine { x: root.xForIndex(9);  y: root.yForValue(root.history[9]) }
      PathLine { x: root.xForIndex(10); y: root.yForValue(root.history[10]) }
      PathLine { x: root.xForIndex(11); y: root.yForValue(root.history[11]) }
      PathLine { x: root.xForIndex(12); y: root.yForValue(root.history[12]) }
      PathLine { x: root.xForIndex(13); y: root.yForValue(root.history[13]) }
      PathLine { x: root.xForIndex(14); y: root.yForValue(root.history[14]) }
      PathLine { x: root.xForIndex(15); y: root.yForValue(root.history[15]) }
      PathLine { x: root.xForIndex(16); y: root.yForValue(root.history[16]) }
      PathLine { x: root.xForIndex(17); y: root.yForValue(root.history[17]) }
      PathLine { x: root.xForIndex(18); y: root.yForValue(root.history[18]) }
      PathLine { x: root.xForIndex(19); y: root.yForValue(root.history[19]) }
      PathLine { x: root.xForIndex(20); y: root.yForValue(root.history[20]) }
      PathLine { x: root.xForIndex(21); y: root.yForValue(root.history[21]) }
      PathLine { x: root.xForIndex(22); y: root.yForValue(root.history[22]) }
      PathLine { x: root.xForIndex(23); y: root.yForValue(root.history[23]) }
      PathLine { x: root.xForIndex(24); y: root.yForValue(root.history[24]) }
      PathLine { x: root.xForIndex(25); y: root.yForValue(root.history[25]) }
      PathLine { x: root.xForIndex(26); y: root.yForValue(root.history[26]) }
      PathLine { x: root.xForIndex(27); y: root.yForValue(root.history[27]) }
      PathLine { x: root.xForIndex(28); y: root.yForValue(root.history[28]) }
      PathLine { x: root.xForIndex(29); y: root.yForValue(root.history[29]) }
    }
  }

  Shape {
    anchors.fill: parent
    antialiasing: true

    ShapePath {
      strokeWidth: 1.8
      strokeColor: root.theme.fg
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin

      startX: root.xForIndex(0)
      startY: root.yForValue(root.history[0])

      PathLine { x: root.xForIndex(1);  y: root.yForValue(root.history[1]) }
      PathLine { x: root.xForIndex(2);  y: root.yForValue(root.history[2]) }
      PathLine { x: root.xForIndex(3);  y: root.yForValue(root.history[3]) }
      PathLine { x: root.xForIndex(4);  y: root.yForValue(root.history[4]) }
      PathLine { x: root.xForIndex(5);  y: root.yForValue(root.history[5]) }
      PathLine { x: root.xForIndex(6);  y: root.yForValue(root.history[6]) }
      PathLine { x: root.xForIndex(7);  y: root.yForValue(root.history[7]) }
      PathLine { x: root.xForIndex(8);  y: root.yForValue(root.history[8]) }
      PathLine { x: root.xForIndex(9);  y: root.yForValue(root.history[9]) }
      PathLine { x: root.xForIndex(10); y: root.yForValue(root.history[10]) }
      PathLine { x: root.xForIndex(11); y: root.yForValue(root.history[11]) }
      PathLine { x: root.xForIndex(12); y: root.yForValue(root.history[12]) }
      PathLine { x: root.xForIndex(13); y: root.yForValue(root.history[13]) }
      PathLine { x: root.xForIndex(14); y: root.yForValue(root.history[14]) }
      PathLine { x: root.xForIndex(15); y: root.yForValue(root.history[15]) }
      PathLine { x: root.xForIndex(16); y: root.yForValue(root.history[16]) }
      PathLine { x: root.xForIndex(17); y: root.yForValue(root.history[17]) }
      PathLine { x: root.xForIndex(18); y: root.yForValue(root.history[18]) }
      PathLine { x: root.xForIndex(19); y: root.yForValue(root.history[19]) }
      PathLine { x: root.xForIndex(20); y: root.yForValue(root.history[20]) }
      PathLine { x: root.xForIndex(21); y: root.yForValue(root.history[21]) }
      PathLine { x: root.xForIndex(22); y: root.yForValue(root.history[22]) }
      PathLine { x: root.xForIndex(23); y: root.yForValue(root.history[23]) }
      PathLine { x: root.xForIndex(24); y: root.yForValue(root.history[24]) }
      PathLine { x: root.xForIndex(25); y: root.yForValue(root.history[25]) }
      PathLine { x: root.xForIndex(26); y: root.yForValue(root.history[26]) }
      PathLine { x: root.xForIndex(27); y: root.yForValue(root.history[27]) }
      PathLine { x: root.xForIndex(28); y: root.yForValue(root.history[28]) }
      PathLine { x: root.xForIndex(29); y: root.yForValue(root.history[29]) }
    }
  }
  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: Quickshell.execDetached(["kitty", "--class", "system-info", "-e", "btop"])
  }
}
