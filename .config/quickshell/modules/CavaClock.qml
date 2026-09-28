import QtQuick
import Quickshell
import "."

Rectangle {
  id: root

  required property QtObject theme
  required property QtObject source
  required property string orientation

  property int barHeight: 3
  property int barSpacing: 3

  color: "transparent"

  Column {
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    spacing: root.barSpacing

    Repeater {
      model: root.source.bars.length

      Rectangle {
        width: Math.max(0, Math.min(root.width, root.width * ((root.source.bars[index] || 0) / 100)))
        height: root.barHeight
        color: root.theme.primary
      }
    }
  }

  Rectangle {
    id: clockBackground
    anchors.centerIn: parent
    width: clock.implicitWidth + 8
    height: clock.implicitHeight + 6
    color: Qt.alpha(root.theme.bg, 0.96)
    radius: 0
    z: 1

    Clock {
      id: clock
      anchors.centerIn: parent
      theme: root.theme
      orientation: root.orientation
    }
  }

  MouseArea {
    anchors.fill: parent
    z: 2
    onClicked: Quickshell.execDetached(["playerctl", "play-pause"])
  }
}
