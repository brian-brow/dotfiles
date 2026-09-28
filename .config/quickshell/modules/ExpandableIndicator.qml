import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  property string valueText
  property bool verticalText: false
  property int maxValueLength: 10
  property bool expanded: mouse.containsMouse

  readonly property string displayValue: valueText.length > maxValueLength
    ? valueText.slice(0, maxValueLength - 3) + "..."
    : valueText

  default property alias content: contentArea.data

  implicitWidth: 36
  implicitHeight: expanded
    ? Math.max(
        48,
        verticalText
          ? contentArea.height + valueLabel.implicitWidth + 8
          : 48
      )
    : 28
  clip: true

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 180
      easing.type: Easing.OutCubic
    }
  }

  Item {
    id: contentArea
    width: parent.width
    height: 28
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
  }

  Text {
    id: valueLabel
    text: root.displayValue
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.tertiary
    y: root.expanded
      ? contentArea.y
        - 2
        - (valueLabel.implicitWidth + valueLabel.implicitHeight) / 2
      : contentArea.y
    opacity: root.expanded ? 1 : 0

    rotation: root.verticalText ? -90 : 0
    transformOrigin: Item.Center

    Behavior on opacity {
      NumberAnimation { duration: 120 }
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    propagateComposedEvents: true
    onClicked: event => event.accepted = false
  }
}
