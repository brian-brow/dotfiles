import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  required property QtObject theme
  property string connectionName: ""
  property string connectionType: ""
  property int signalStrength: 0
  property bool connected: false

  implicitWidth: 24
  implicitHeight: 24

  function refreshNetwork() {
    networkProc.running = false
    networkProc.running = true
  }

  function iconForState() {
    if (!connected) return "󰖪"
    if (connectionType === "ethernet") return "󰈀"
    if (signalStrength < 20) return "󰤯"
    if (signalStrength < 40) return "󰤟"
    if (signalStrength < 60) return "󰤢"
    if (signalStrength < 80) return "󰤥"
    return "󰤨"
  }

  scale: netMouse.pressed ? 0.88 : 1.0
  Behavior on scale {
    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
  }

  Text {
    anchors.centerIn: parent
    text: root.iconForState()
    color: theme.tertiary
    font.family: theme.fontFamily
    font.pixelSize: 24
    font.bold: true
  }

  MouseArea {
    id: netMouse
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: toggleProc.running = true
  }

  Process {
    id: toggleProc
    command: ["/home/brian/.config/hypr/scripts/toggle_tui.sh", "nmtui"]
  }

  Process {
    id: networkProc
    command: [
      "bash",
      "-c",
      "active=$(nmcli -t -f NAME,TYPE connection show --active | head -n 1); wifi=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes'); echo \"$active|$wifi\""
    ]

    stdout: SplitParser {
      onRead: data => {
        const text = data.trim()

        root.connectionName = ""
        root.connectionType = ""
        root.signalStrength = 0
        root.connected = false

        if (!text)
        return

        const parts = text.split("|")
        const active = parts[0] || ""
        const wifi = parts[1] || ""

        if (active) {
          const activeParts = active.split(":")
          root.connectionName = activeParts[0] || ""
          root.connectionType = activeParts[1] || ""
          root.connected = true
        }

        if (wifi) {
          const wifiParts = wifi.split(":")
          root.connectionName = wifiParts[1] || root.connectionName
          root.signalStrength = parseInt(wifiParts[2] || "0")
          if (isNaN(root.signalStrength))
          root.signalStrength = 0
        }
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: root.refreshNetwork()
  }

  Component.onCompleted: root.refreshNetwork()
}
