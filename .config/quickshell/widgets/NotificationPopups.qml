import QtQuick
import Quickshell
import Quickshell.Wayland
import "../services" as Services
import "."

PanelWindow {
  id: root

  required property QtObject theme

  anchors {
    top: true
    right: true
  }

  margins {
    top: 14
    right: 14
  }

  implicitWidth: 400
  implicitHeight: notifColumn.implicitHeight
  visible: notifColumn.implicitHeight > 0
  color: "transparent"
  focusable: false
  aboveWindows: true

  Column {
    id: notifColumn
    anchors.top: parent.top
    anchors.right: parent.right
    width: 400
    spacing: 8

    Repeater {
      model: Services.Notifications.notifications

      delegate: Item {
        required property var modelData

        width: notifColumn.width
        height: toast.implicitHeight
        visible: !!modelData

        NotificationToast {
          id: toast
          anchors.right: parent.right
          width: 380
          theme: root.theme
          notification: modelData

          onDismissRequested: modelData.dismiss()
        }

        Component.onCompleted: {
          console.log("popup delegate:", modelData.summary, "toast height:", toast.implicitHeight)
        }

        Timer {
          running: parent.visible && !hoverArea.containsMouse
          interval: 5000
          repeat: false
          onTriggered: {
            if (modelData)
              modelData.dismiss()
          }
        }

        MouseArea {
          id: hoverArea
          anchors.fill: parent
          hoverEnabled: true
          acceptedButtons: Qt.NoButton
        }
      }
    }
  }
}
