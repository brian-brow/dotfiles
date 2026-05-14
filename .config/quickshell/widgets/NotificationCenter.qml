import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../services" as Services
import "."

PanelWindow {
  id: root

  required property QtObject theme

  visible: Services.Notifications.centerOpen
  focusable: true
  color: "transparent"

  implicitWidth: 420
  implicitHeight: 520

  anchors {
    top: true
    right: true
  }

  margins {
    top: 14
    right: 14
  }

  Rectangle {
    anchors.fill: parent
    radius: 16
    color: theme.bg
    border.width: 1
    border.color: Qt.alpha(theme.fg, 0.10)

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      RowLayout {
        Layout.fillWidth: true

        Text {
          text: "Notifications"
          color: theme.fg
          font.pixelSize: 18
          font.bold: true
          Layout.fillWidth: true
        }

        Button {
          id: clearButton
          implicitHeight: 30

          contentItem: Text {
            text: "Clear all"
            color: theme.on_primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 11
            font.bold: true
          }

          background: Rectangle {
            radius: 8
            color: clearButton.down
              ? Qt.alpha(theme.primary, 1.0)
              : clearButton.hovered
                ? Qt.alpha(theme.primary, 0.82)
                : Qt.alpha(theme.primary, 0.68)
          }

          onClicked: {
            const notifs = Services.Notifications.notifications
            for (let i = notifs.length - 1; i >= 0; --i) {
              const n = notifs[i]
              if (n)
                n.dismiss()
            }
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 12
        color: Qt.alpha(theme.fg, 0.04)
        clip: true

        Flickable {
          anchors.fill: parent
          contentWidth: width
          contentHeight: contentCol.implicitHeight
          boundsBehavior: Flickable.StopAtBounds
          clip: true

          Column {
            id: contentCol
            width: parent.width
            spacing: 8

            Repeater {
              model: Services.Notifications.notifications

              delegate: Item {
                required property var modelData

                width: contentCol.width
                height: toast.implicitHeight + 16

                NotificationToast {
                  id: toast
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.margins: 8
                  theme: root.theme
                  notification: modelData

                  onDismissRequested: modelData.dismiss()
                }
              }
            }

            Item {
              width: parent.width
              height: Services.Notifications.notifications.length === 0 ? 120 : 0
              visible: height > 0

              Text {
                anchors.centerIn: parent
                text: "No notifications"
                color: Qt.alpha(theme.fg, 0.55)
                font.pixelSize: 13
              }
            }
          }
        }
      }
    }
  }
}
