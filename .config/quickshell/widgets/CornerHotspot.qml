import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
  id: root

  required property ShellScreen modelData

  screen: modelData
  anchors.top: true
  anchors.right: true
  implicitWidth: 8
  implicitHeight: 8
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  property bool triggered: false

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    onEntered: {
      if (root.triggered) return
      root.triggered = true
      Quickshell.execDetached(["swaync-client", "-t", "-sw"])
    }

    onExited: root.triggered = false
  }
}
