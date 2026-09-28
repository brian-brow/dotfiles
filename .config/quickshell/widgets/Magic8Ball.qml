import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
  id: root
  implicitWidth: 620
  implicitHeight: 620
  color: "transparent"

  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  HyprlandFocusGrab {
    id: focusGrab
    windows: [root]
    onCleared: root.visible = false
  }

  property var responses: [
    "It is certain",
    "It is decidedly so",
    "Without a doubt",
    "Yes definitely",
    "You may rely on it",
    "As I see it, yes",
    "Most likely",
    "Outlook good",
    "Yes",
    "Signs point to yes",
    "Reply hazy, try again",
    "Ask again later",
    "Better not tell you now",
    "Cannot predict now",
    "Concentrate and ask again",
    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful"
  ]
  property string answer: "Ask me anything"
  property bool dragging: false
  property bool hasShaken: false
  visible: false
  focusable: true

  onVisibleChanged: {
    focusGrab.active = visible
    if (visible) {
      keyHandler.forceActiveFocus()
    }
  }

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  Item {
    id: keyHandler
    anchors.fill: parent
    focus: true
    Keys.onEscapePressed: root.visible = false
  }

  Rectangle {
    anchors.fill: parent
    radius: 20
    color: "transparent"
    clip: true
    ColumnLayout {
      anchors.centerIn: parent
      spacing: 10
      Rectangle {
        id: panel
        width: 520
        height: 520
        radius: width / 2
        color: "#070707"
        Rectangle {
          anchors.centerIn: parent
          width: parent.width / 2.13
          height: parent.width / 2.13
          radius: width / 2
          color: "white"
          visible: !root.hasShaken || root.dragging
          Text {
            anchors.centerIn: parent
            text: "8"
            font.pixelSize: 60
            color: "black"
          }
        }
        Rectangle {
          anchors.centerIn: parent
          width: parent.width / 2.13
          height: parent.width / 2.13
          radius: width / 2
          border.color: "white"
          color: "transparent"
          visible: root.hasShaken && !root.dragging
          Canvas {
            width: parent.width / 1.5
            height: parent.width / 1.5
            anchors.centerIn: parent
            onPaint: {
              var ctx = getContext("2d")
              ctx.reset()
              var w = width
              var h = height
              ctx.beginPath()
              ctx.moveTo(w * 0.12, h * 0.18)
              ctx.lineTo(w * 0.88, h * 0.18)
              ctx.lineTo(w / 2, h * 0.92)
              ctx.closePath()
              ctx.fillStyle = "#0038e4"
              ctx.fill()
            }
            Text {
              anchors.centerIn: parent
              anchors.verticalCenterOffset: -10
              width: parent.width * 0.4
              text: root.answer
              wrapMode: Text.WordWrap
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              color: "white"
              font.pixelSize: 16
            }
          }
        }
        MouseArea {
          anchors.fill: parent
          drag.target: panel
          drag.axis: Drag.XAndYAxis
          drag.minimumX: -(root.width - panel.width)
          drag.minimumY: -(root.height - panel.height)
          drag.maximumX: root.width - panel.width
          drag.maximumY: root.height - panel.height
          onPressed: root.dragging = true
          onReleased: {
            root.dragging = false
            root.hasShaken = true
            root.answer = root.responses[Math.floor(Math.random() * root.responses.length)]
          }
        }
      }
    }
  }
}
