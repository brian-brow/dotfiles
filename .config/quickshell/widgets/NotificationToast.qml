import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
  id: root

  required property var notification
  required property QtObject theme

  radius: 12
  color: theme.bg
  border.width: 1
  border.color: Qt.alpha(theme.fg, 0.10)

  implicitWidth: 360
  implicitHeight: contentColumn.implicitHeight + 20

  signal dismissRequested()

  ColumnLayout {
    id: contentColumn
    x: 10
    y: 10
    width: root.width - 20
    spacing: 8

    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      Rectangle {
        width: 28
        height: 28
        radius: 8
        color: Qt.alpha(theme.primary, 0.16)

        Text {
          anchors.centerIn: parent
          text: "󰂚"
          color: theme.primary
          font.pixelSize: 15
        }
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        Text {
          text: notification.appName || "Notification"
          color: Qt.alpha(theme.fg, 0.72)
          font.pixelSize: 11
          elide: Text.ElideRight
          Layout.fillWidth: true
        }

        Text {
          text: notification.summary || ""
          color: theme.fg
          font.pixelSize: 13
          font.bold: true
          wrapMode: Text.Wrap
          Layout.fillWidth: true
        }
      }

      Text {
        id: closeText
        text: "󰅖"
        color: Qt.alpha(theme.fg, closeMouse.containsMouse ? 0.9 : 0.55)
        font.pixelSize: 14

        MouseArea {
          id: closeMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.dismissRequested()
        }
      }
    }

    Text {
      visible: (notification.body || "").length > 0
      text: notification.body || ""
      color: Qt.alpha(theme.fg, 0.82)
      font.pixelSize: 12
      wrapMode: Text.Wrap
      Layout.fillWidth: true
    }

    Repeater {
      model: notification.actions || []

      delegate: Button {
        id: actionButton
        required property var modelData

        Layout.fillWidth: true
        implicitHeight: 30

        contentItem: Text {
          text: modelData.text || "Action"
          color: actionButton.enabled
            ? theme.on_primary
            : Qt.alpha(theme.on_surface, 0.45)
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 11
          font.bold: true
        }

        background: Rectangle {
          radius: 8
          color: actionButton.down
            ? Qt.alpha(theme.primary, 1.0)
            : actionButton.hovered
              ? Qt.alpha(theme.primary, 0.82)
              : Qt.alpha(theme.primary, 0.68)

          Behavior on color {
            ColorAnimation { duration: 100 }
          }
        }

        onClicked: modelData.invoke()
      }
    }

    Item {
      visible: notification.hasInlineReply
      Layout.fillWidth: true
      implicitHeight: visible ? replyRow.implicitHeight : 0

      RowLayout {
        id: replyRow
        width: parent.width
        spacing: 8

        TextField {
          id: replyField
          Layout.fillWidth: true
          placeholderText: notification.inlineReplyPlaceholder || "Reply"
          color: theme.fg
          placeholderTextColor: Qt.alpha(theme.fg, 0.45)

          background: Rectangle {
            radius: 8
            color: Qt.alpha(theme.fg, 0.05)
            border.width: 1
            border.color: Qt.alpha(theme.fg, 0.10)
          }

          onAccepted: {
            if (text.trim().length > 0) {
              notification.sendInlineReply(text)
              text = ""
            }
          }
        }

        Button {
          id: sendButton
          enabled: replyField.text.trim().length > 0
          implicitHeight: 34

          contentItem: Text {
            text: "Send"
            color: sendButton.enabled
              ? theme.on_primary
              : Qt.alpha(theme.on_surface, 0.45)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 11
            font.bold: true
          }

          background: Rectangle {
            radius: 8
            color: !sendButton.enabled
              ? Qt.alpha(theme.primary, 0.28)
              : sendButton.down
                ? Qt.alpha(theme.primary, 1.0)
                : sendButton.hovered
                  ? Qt.alpha(theme.primary, 0.82)
                  : Qt.alpha(theme.primary, 0.68)

            Behavior on color {
              ColorAnimation { duration: 100 }
            }
          }

          onClicked: {
            notification.sendInlineReply(replyField.text)
            replyField.text = ""
          }
        }
      }
    }
  }
}
