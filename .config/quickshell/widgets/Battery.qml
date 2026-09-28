pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.UPower

PanelWindow {
  id: root
  property bool dragging: false
  visible: false
  color: "transparent"

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  focusable: true

  // ── Dismiss on click outside ─────────────────────────────────────────
  MouseArea {
    anchors.fill: parent
    onClicked: root.visible = false
    z: 0
  }

  // ── Centered container (eats clicks so dismiss doesn't fire) ─────────
  MouseArea {
    id: container
    anchors.left: parent.horizontalCenter  // left edge stays fixed at screen center
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: -60               // pull back by half the square width (120/2)
    width: square.width + extensionClip.width
    height: square.height
    onClicked: {}
    z: 1

    HoverHandler { id: hov }

    // ── Main square ──────────────────────────────────────────────────
    Rectangle {
      id: square
      width: 120
      height: 120
      radius: 14
      color: "#1e1e2e"
      border.color: "transparent"
      border.width: 1
      z: 2

      // Small inner circle placeholder
      Rectangle {
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 20
        color: "#313244"
        border.color: "#45475a"
        border.width: 1
      }
    }

    // ── Clipped extension panel ──────────────────────────────────────
    Rectangle {
      id: extensionClip
      anchors.left: square.right
      anchors.leftMargin: -14        // overlap so border seam is hidden
      anchors.verticalCenter: square.verticalCenter
      height: square.height
      clip: true
      color: "transparent"

      width: hov.hovered ? 160 : 0
      Behavior on width {
        NumberAnimation {
          duration: 320
          easing.type: Easing.OutBack
          easing.overshoot: 1.2
        }
      }

      // ── Extension body ───────────────────────────────────────────
      Rectangle {
        id: extension
        anchors.right: parent.right
        width: 160
        height: square.height
        radius: 14
        color: "#1e1e2e"
        border.color: "transparent"
        border.width: 1

        // Cover the left rounded corners so it merges with square
        Rectangle {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: 20
          color: "#1e1e2e"
        }
        // Cover the left border line too
        Rectangle {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: 1
          color: "#1e1e2e"
        }

        // ── White circle ─────────────────────────────────────────
        Rectangle {
          anchors.centerIn: parent
          anchors.horizontalCenterOffset: 8
          width: 64
          height: 64
          radius: 32
          color: "white"

          opacity: hov.hovered ? 1 : 0
          scale: hov.hovered ? 1 : 0.7

          Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
          }
          Behavior on scale {
            NumberAnimation {
              duration: 280
              easing.type: Easing.OutBack
              easing.overshoot: 1.4
            }
          }
        }
      }
    }
  }
}
