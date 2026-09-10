import QtQuick
import Quickshell.Io

Rectangle {
  id: root
  required property QtObject theme
  required property QtObject source

  property int startIndex: 0
  property int visibleBarCount: 20
  property bool mirror: false
  property int minBarHeight: 3
  property int barWidth: 3
  property int barSpacing: 3
  property int barRadius: 8
  property int padding: 8
  property bool containsMouse: false
  Timer {
    id: debounceTimer
    interval: 120
    repeat: false
    onTriggered: {
      root.containsMouse = false
    }
  }

  signal hoveredChanged(bool hovered)

  implicitWidth: visibleBarCount * (barWidth + barSpacing) - barSpacing + padding * 2

  // A faint tint of the foreground rather than an opaque surface, so the chip
  // reads as a slight lift in the bar and the blur behind still shows through.
  color: root.containsMouse ? Qt.alpha(theme.fg, 0.12) : Qt.alpha(theme.inverse_primary, 0.3)
  Behavior on color { ColorAnimation { duration: 120 } }

  radius: 16

  Row {
    anchors.fill: parent
    anchors.leftMargin: root.padding
    anchors.rightMargin: root.padding
    spacing: root.barSpacing

    Repeater {
      model: root.visibleBarCount
      Rectangle {
        readonly property int sourceIndex: root.mirror
        ? root.startIndex + (root.visibleBarCount - 1 - index)
        : root.startIndex + index

        width: root.barWidth
        height: {
          const value = root.source.bars[sourceIndex] || 0
          return Math.min(root.height, Math.max(root.minBarHeight, (value / 100) * root.height))
        }
        radius: root.barRadius
        color: root.theme.primary
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    z: 10
    cursorShape: Qt.PointingHandCursor
    onClicked: toggleProc.running = true

    onContainsMouseChanged: {
      if (containsMouse) {
        debounceTimer.stop()
        root.containsMouse = true
      } else {
        debounceTimer.start()
      }
    }
  }

  Process {
    id: toggleProc
    command: ["playerctl", "play-pause"]
  }
}
