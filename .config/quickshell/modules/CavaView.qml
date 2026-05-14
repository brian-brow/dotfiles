import QtQuick
import Quickshell.Io

Item {
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
  property bool showBackground: true

  implicitWidth: visibleBarCount * (barWidth + barSpacing) - barSpacing + padding * 2

  Rectangle {
    color: root.showBackground ? root.theme.bg : "transparent"
    radius: 16

    anchors.fill: parent

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

          // width: (root.width - ((root.visibleBarCount - 1) * root.barSpacing)) / root.visibleBarCount
          width: 3
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
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: toggleProc.running = true
    }
  }

  Process {
    id: toggleProc
    command: ["playerctl", "play-pause"]
    onRunningChanged: if (!running) running = false
  }
}
