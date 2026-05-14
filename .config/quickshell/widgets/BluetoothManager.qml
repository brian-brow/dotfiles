import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root

  required property QtObject theme

  property var bluetoothDevices: []
  property string expandedAddress: ""
  property string pendingAddress: ""
  property bool scanning: false

  visible: false
  focusable: true

  width: 420
  height: 420
  color: "transparent"

  function refreshDevices() {
    listDevicesProc.running = false
    infoDevicesProc.running = false

    listDevicesProc.running = true
    infoDevicesProc.running = true
  }

  function parseDeviceList(text) {
    const lines = text.trim().split("\n")
    let devices = []

    for (const line of lines) {
      const trimmed = line.trim()
      if (!trimmed)
        continue

      // bluetoothctl devices format:
      // Device XX:XX:XX:XX:XX:XX Device Name
      const match = trimmed.match(/^Device\s+([0-9A-F:]+)\s+(.+)$/i)
      if (!match)
        continue

      devices.push({
        address: match[1],
        name: match[2],
        connected: false,
        paired: false,
        trusted: false,
        blocked: false,
        rssi: null
      })
    }

    root.bluetoothDevices = devices
  }

  function parseDeviceInfo(text) {
    const blocks = text.split("\n\n")
    let infoMap = {}

    for (const block of blocks) {
      const lines = block.trim().split("\n")
      if (lines.length === 0)
        continue

      let address = ""
      let connected = false
      let paired = false
      let trusted = false
      let blocked = false
      let rssi = null

      for (const line of lines) {
        const trimmed = line.trim()

        if (trimmed.startsWith("Device ")) {
          const match = trimmed.match(/^Device\s+([0-9A-F:]+)/i)
          if (match)
            address = match[1]
        } else if (trimmed.startsWith("Connected:")) {
          connected = trimmed.includes("yes")
        } else if (trimmed.startsWith("Paired:")) {
          paired = trimmed.includes("yes")
        } else if (trimmed.startsWith("Trusted:")) {
          trusted = trimmed.includes("yes")
        } else if (trimmed.startsWith("Blocked:")) {
          blocked = trimmed.includes("yes")
        } else if (trimmed.startsWith("RSSI:")) {
          const parts = trimmed.split(":")
          if (parts.length > 1)
            rssi = parseInt(parts[1].trim())
        }
      }

      if (address) {
        infoMap[address] = {
          connected: connected,
          paired: paired,
          trusted: trusted,
          blocked: blocked,
          rssi: rssi
        }
      }
    }

    root.bluetoothDevices = root.bluetoothDevices.map(device => {
      const info = infoMap[device.address]
      return info ? {
        address: device.address,
        name: device.name,
        connected: info.connected,
        paired: info.paired,
        trusted: info.trusted,
        blocked: info.blocked,
        rssi: info.rssi
      } : device
    })
  }

  function bluetoothIcon(device) {
    if (device.connected) return "󰂱"
    if (device.paired) return "󰂯"
    return "󰂲"
  }

  function bluetoothStatus(device) {
    if (device.connected) return "Connected"
    if (device.paired) return "Paired"
    return "Available"
  }

  function bluetoothMeta(device) {
    let pieces = []

    if (device.trusted)
      pieces.push("Trusted")

    if (device.rssi !== null && !isNaN(device.rssi))
      pieces.push(`RSSI ${device.rssi}`)

    return pieces.join(" • ")
  }

  function toggleExpanded(address) {
    root.expandedAddress = root.expandedAddress === address ? "" : address
  }

  function runBluetoothCommand(args, address) {
    root.pendingAddress = address
    bluetoothAction.running = false
    bluetoothAction.command = ["bluetoothctl"].concat(args)
    bluetoothAction.running = true
  }

  function pairDevice(address) {
    // Pairing agent/pin handling is usually done by the system agent.
    runBluetoothCommand(["pair", address], address)
  }

  function trustDevice(address) {
    runBluetoothCommand(["trust", address], address)
  }

  function connectDevice(address, paired, trusted) {
    if (!paired) {
      pairDevice(address)
      return
    }

    if (!trusted) {
      bluetoothChainAction = "trust_then_connect"
      trustDevice(address)
      return
    }

    bluetoothChainAction = ""
    runBluetoothCommand(["connect", address], address)
  }

  function disconnectDevice(address) {
    bluetoothChainAction = ""
    runBluetoothCommand(["disconnect", address], address)
  }

  function removeDevice(address) {
    bluetoothChainAction = ""
    runBluetoothCommand(["remove", address], address)
  }

  function startScan() {
    scanOnProc.running = false
    scanOnProc.running = true
    root.scanning = true
  }

  function stopScan() {
    scanOffProc.running = false
    scanOffProc.running = true
    root.scanning = false
  }

  property string bluetoothChainAction: ""

  Rectangle {
    anchors.fill: parent
    radius: 14
    color: root.theme.bg
    border.width: 1
    border.color: Qt.alpha(root.theme.fg, 0.12)

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      RowLayout {
        Layout.fillWidth: true

        Text {
          text: "Bluetooth Devices"
          color: root.theme.fg
          font.pixelSize: 18
          font.bold: true
          Layout.fillWidth: true
        }

        Button {
          id: scanButton
          implicitHeight: 28
          implicitWidth: 72

          contentItem: Text {
            text: root.scanning ? "Stop" : "Scan"
            color: root.theme.on_primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
            font.bold: true
          }

          background: Rectangle {
            radius: 6
            color: scanButton.down
              ? Qt.alpha(root.theme.primary, 1.0)
              : scanButton.hovered
                ? Qt.alpha(root.theme.primary, 0.82)
                : Qt.alpha(root.theme.primary, 0.68)

            Behavior on color {
              ColorAnimation { duration: 120 }
            }
          }

          onClicked: {
            if (root.scanning)
              root.stopScan()
            else
              root.startScan()
          }
        }

        Text {
          text: "󰑐"
          color: root.theme.fg
          font.pixelSize: 16

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.refreshDevices()
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 10
        color: Qt.alpha(root.theme.fg, 0.04)
        clip: true

        Flickable {
          anchors.fill: parent
          contentWidth: width
          contentHeight: listColumn.implicitHeight
          boundsBehavior: Flickable.StopAtBounds
          clip: true

          Column {
            id: listColumn
            width: parent.width
            spacing: 6

            Repeater {
              model: root.bluetoothDevices

              delegate: Rectangle {
                required property var modelData

                width: listColumn.width
                height: deviceColumn.implicitHeight + 12
                radius: 8

                color: modelData.connected
                  ? Qt.alpha(root.theme.primary, 0.18)
                  : rowMouse.containsMouse
                    ? Qt.alpha(root.theme.fg, 0.08)
                    : "transparent"

                Behavior on color {
                  ColorAnimation { duration: 120 }
                }

                ColumnLayout {
                  id: deviceColumn
                  anchors.fill: parent
                  anchors.margins: 6
                  spacing: 8

                  Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 6
                    color: "transparent"

                    RowLayout {
                      anchors.fill: parent
                      anchors.leftMargin: 6
                      anchors.rightMargin: 6
                      spacing: 12

                      Text {
                        text: root.bluetoothIcon(modelData)
                        color: modelData.connected ? root.theme.primary : root.theme.fg
                        font.pixelSize: 18
                      }

                      ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                          text: modelData.name
                          color: root.theme.fg
                          font.pixelSize: 13
                          font.bold: modelData.connected
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }

                        Text {
                          text: root.bluetoothMeta(modelData).length > 0
                            ? `${modelData.address} • ${root.bluetoothMeta(modelData)}`
                            : modelData.address
                          color: Qt.alpha(root.theme.fg, 0.65)
                          font.pixelSize: 11
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }
                      }

                      Text {
                        text: root.bluetoothStatus(modelData)
                        color: modelData.connected ? root.theme.primary : Qt.alpha(root.theme.fg, 0.6)
                        font.pixelSize: 11
                        font.bold: modelData.connected
                      }
                    }

                    MouseArea {
                      id: rowMouse
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor
                      onClicked: root.toggleExpanded(modelData.address)
                    }
                  }

                  Item {
                    id: expandWrapper
                    Layout.fillWidth: true
                    clip: true

                    property bool expanded: root.expandedAddress === modelData.address

                    implicitHeight: expanded ? actionRow.implicitHeight : 0
                    opacity: expanded ? 1 : 0
                    visible: implicitHeight > 0 || opacity > 0

                    Behavior on implicitHeight {
                      NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                      }
                    }

                    Behavior on opacity {
                      NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutQuad
                      }
                    }

                    ColumnLayout {
                      id: actionRow
                      anchors.left: parent.left
                      anchors.right: parent.right
                      spacing: 8

                      Rectangle {
                        Layout.fillWidth: true
                        radius: 8
                        color: Qt.alpha(root.theme.fg, 0.05)
                        border.width: 1
                        border.color: Qt.alpha(root.theme.fg, 0.08)
                        implicitHeight: controlsColumn.implicitHeight + 16

                        ColumnLayout {
                          id: controlsColumn
                          anchors.fill: parent
                          anchors.margins: 8
                          spacing: 8

                          Text {
                            text: modelData.connected
                              ? "Device is currently connected."
                              : modelData.paired
                                ? "Device is paired and ready to connect."
                                : "Device is not paired yet."
                            color: Qt.alpha(root.theme.fg, 0.78)
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                          }

                          RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Button {
                              id: pairButton
                              visible: !modelData.paired
                              implicitHeight: 34

                              contentItem: Text {
                                text: "Pair"
                                color: root.theme.on_primary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 12
                                font.bold: true
                              }

                              background: Rectangle {
                                radius: 6
                                color: pairButton.down
                                  ? Qt.alpha(root.theme.primary, 1.00)
                                  : pairButton.hovered
                                    ? Qt.alpha(root.theme.primary, 0.82)
                                    : Qt.alpha(root.theme.primary, 0.68)

                                Behavior on color {
                                  ColorAnimation { duration: 120 }
                                }
                              }

                              onClicked: root.pairDevice(modelData.address)
                            }

                            Button {
                              id: connectButton
                              visible: !modelData.connected
                              implicitHeight: 34

                              contentItem: Text {
                                text: modelData.paired ? "Connect" : "Pair & Connect"
                                color: root.theme.on_primary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 12
                                font.bold: true
                              }

                              background: Rectangle {
                                radius: 6
                                color: connectButton.down
                                  ? Qt.alpha(root.theme.primary, 1.00)
                                  : connectButton.hovered
                                    ? Qt.alpha(root.theme.primary, 0.82)
                                    : Qt.alpha(root.theme.primary, 0.68)

                                scale: connectButton.down ? 0.98 : (connectButton.hovered ? 1.01 : 1.0)

                                Behavior on color {
                                  ColorAnimation { duration: 120 }
                                }

                                Behavior on scale {
                                  NumberAnimation { duration: 100 }
                                }
                              }

                              onClicked: root.connectDevice(
                                modelData.address,
                                modelData.paired,
                                modelData.trusted
                              )
                            }

                            Button {
                              id: disconnectButton
                              visible: modelData.connected
                              implicitHeight: 34

                              contentItem: Text {
                                text: "Disconnect"
                                color: root.theme.on_secondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 12
                                font.bold: true
                              }

                              background: Rectangle {
                                radius: 6
                                color: disconnectButton.down
                                  ? Qt.alpha(root.theme.secondary, 1.00)
                                  : disconnectButton.hovered
                                    ? Qt.alpha(root.theme.secondary, 0.82)
                                    : Qt.alpha(root.theme.secondary, 0.68)

                                Behavior on color {
                                  ColorAnimation { duration: 120 }
                                }
                              }

                              onClicked: root.disconnectDevice(modelData.address)
                            }

                            Item { Layout.fillWidth: true }

                            Button {
                              id: removeButton
                              visible: modelData.paired
                              implicitHeight: 34

                              contentItem: Text {
                                text: "Remove"
                                color: root.theme.on_error
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 12
                                font.bold: true
                              }

                              background: Rectangle {
                                radius: 6
                                color: removeButton.down
                                  ? Qt.alpha(root.theme.error, 1.00)
                                  : removeButton.hovered
                                    ? Qt.alpha(root.theme.error, 0.82)
                                    : Qt.alpha(root.theme.error, 0.68)

                                Behavior on color {
                                  ColorAnimation { duration: 120 }
                                }
                              }

                              onClicked: root.removeDevice(modelData.address)
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  Process {
    id: listDevicesProc
    command: [
      "bash",
      "-c",
      "bluetoothctl devices"
    ]

    stdout: StdioCollector {
      onStreamFinished: root.parseDeviceList(this.text)
    }
  }

  Process {
    id: infoDevicesProc
    command: [
      "bash",
      "-c",
      "bluetoothctl devices | awk '{print $2}' | while read mac; do bluetoothctl info \"$mac\"; echo; done"
    ]

    stdout: StdioCollector {
      onStreamFinished: root.parseDeviceInfo(this.text)
    }
  }

  Process {
    id: bluetoothAction

    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Bluetooth stdout:", this.text)
      }
    }

    stderr: StdioCollector {
      onStreamFinished: {
        console.log("Bluetooth stderr:", this.text)
      }
    }

    onExited: function(exitCode) {
      console.log("bluetoothctl exited with:", exitCode)

      if (exitCode !== 0)
        return

      if (root.bluetoothChainAction === "trust_then_connect") {
        root.bluetoothChainAction = ""
        root.runBluetoothCommand(["connect", root.pendingAddress], root.pendingAddress)
        return
      }

      root.refreshDevices()
    }
  }

  Process {
    id: scanOnProc
    command: [
      "bash",
      "-c",
      "bluetoothctl scan on"
    ]

    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  Process {
    id: scanOffProc
    command: [
      "bash",
      "-c",
      "bluetoothctl scan off"
    ]

    stdout: StdioCollector {}
    stderr: StdioCollector {}
  }

  Timer {
    interval: 5000
    running: root.visible
    repeat: true
    onTriggered: root.refreshDevices()
  }

  Component.onCompleted: root.refreshDevices()
}
