import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root

  required property QtObject theme

  property var wifiNetworks: []
  property string activeSsid: ""
  property var savedConnections: []

  property string expandedSsid: ""
  property string passwordText: ""
  property string pendingSsid: ""

  visible: false
  focusable: true

  width: 420
  height: 360
  color: "transparent"

  function refreshNetworks() {
    wifiProc.running = false
    activeProc.running = false
    savedProc.running = false

    wifiProc.running = true
    activeProc.running = true
    savedProc.running = true
  }

  function isSaved(ssid) {
    return root.savedConnections.indexOf(ssid) !== -1
  }

  function parseWifiOutput(text) {
    const lines = text.trim().split("\n")
    let networks = []

    for (const line of lines) {
      const trimmed = line.trim()
      if (!trimmed)
      continue

      const parts = trimmed.split(":")
      if (parts.length < 3)
      continue

      const ssid = parts[0]
      const signal = parseInt(parts[1]) || 0
      const security = parts.slice(2).join(":") || "Open"

      if (!ssid)
      continue

      networks.push({
        active: ssid === root.activeSsid,
        ssid: ssid,
        signal: signal,
        security: security
      })
    }

    root.wifiNetworks = networks
  }

  function signalIcon(signal) {
    if (signal < 20) return "󰤯"
    if (signal < 40) return "󰤟"
    if (signal < 60) return "󰤢"
    if (signal < 80) return "󰤥"
    return "󰤨"
  }

  function isSecureNetwork(security) {
    const sec = (security || "").trim().toUpperCase()

    return sec !== "" &&
    sec !== "OPEN" &&
    sec !== "--" &&
    sec !== "NONE"
  }

  function connectToNetwork(ssid, security, password) {
    pendingSsid = ssid
    connectNetwork.running = false

    if (isSaved(ssid)) {
      connectNetwork.command = ["nmcli", "connection", "up", ssid]
    } else if (isSecureNetwork(security)) {
      connectNetwork.command = ["nmcli", "dev", "wifi", "connect", ssid, "password", password]
    } else {
      connectNetwork.command = ["nmcli", "dev", "wifi", "connect", ssid]
    }

    connectNetwork.running = true
  }

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
          text: "Wi-Fi Networks"
          color: root.theme.fg
          font.pixelSize: 18
          font.bold: true
          Layout.fillWidth: true
        }

        Text {
          text: "󰑐"
          color: root.theme.fg
          font.pixelSize: 16

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.refreshNetworks()
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
              model: root.wifiNetworks

              delegate: Rectangle {
                required property var modelData

                width: listColumn.width
                height: networkColumn.implicitHeight + 12
                radius: 8

                color: modelData.active
                ? Qt.alpha(root.theme.primary, 0.18)
                : rowMouse.containsMouse
                ? Qt.alpha(root.theme.fg, 0.08)
                : "transparent"

                Behavior on color {
                  ColorAnimation { duration: 120 }
                }

                ColumnLayout {
                  id: networkColumn
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
                        text: root.signalIcon(modelData.signal)
                        color: modelData.active ? root.theme.primary : root.theme.fg
                        font.pixelSize: 18
                      }

                      ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                          text: modelData.ssid
                          color: root.theme.fg
                          font.pixelSize: 13
                          font.bold: modelData.active
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }

                        Text {
                          text: `${modelData.security} • ${modelData.signal}%`
                          color: Qt.alpha(root.theme.fg, 0.65)
                          font.pixelSize: 11
                          elide: Text.ElideRight
                          Layout.fillWidth: true
                        }
                      }

                      Text {
                        text: modelData.active ? "Connected"
                        : root.isSecureNetwork(modelData.security) ? "Secured"
                        : "Open"
                        color: modelData.active ? root.theme.primary : Qt.alpha(root.theme.fg, 0.6)
                        font.pixelSize: 11
                        font.bold: modelData.active
                      }
                    }

                    MouseArea {
                      id: rowMouse
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor

                      onClicked: {
                        if (root.isSecureNetwork(modelData.security) && !root.isSaved(modelData.ssid)) {
                          if (root.expandedSsid === modelData.ssid) {
                            root.expandedSsid = ""
                            root.passwordText = ""
                          } else {
                            root.expandedSsid = modelData.ssid
                            root.passwordText = ""
                          }
                        } else {
                          root.expandedSsid = ""
                          root.passwordText = ""
                          root.connectToNetwork(modelData.ssid, modelData.security, "")
                        }
                      }
                    }
                  }

                  Item {
                    id: expandWrapper
                    Layout.fillWidth: true
                    clip: true

                    property bool expanded: root.expandedSsid === modelData.ssid
                    && root.isSecureNetwork(modelData.security)
                    && !root.isSaved(modelData.ssid)

                    implicitHeight: expanded ? secureRow.implicitHeight : 0
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
                      id: secureRow
                      anchors.left: parent.left
                      anchors.right: parent.right
                      spacing: 8

                      Rectangle {
                        Layout.fillWidth: true
                        radius: 8
                        color: Qt.alpha(root.theme.fg, 0.05)
                        border.width: 1
                        border.color: Qt.alpha(root.theme.fg, 0.08)
                        implicitHeight: inputRow.implicitHeight + 16

                        ColumnLayout {
                          id: inputRow
                          anchors.fill: parent
                          anchors.margins: 8
                          spacing: 8

                          TextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: "Enter Wi-Fi password"
                            text: root.expandedSsid === modelData.ssid ? root.passwordText : ""
                            echoMode: TextInput.Password
                            color: root.theme.fg
                            placeholderTextColor: Qt.alpha(root.theme.fg, 0.45)
                            selectByMouse: true

                            background: Rectangle {
                              radius: 6
                              color: Qt.alpha(root.theme.bg, 0.9)
                              border.width: 1
                              border.color: Qt.alpha(root.theme.fg, 0.12)
                            }

                            onTextChanged: {
                              if (root.expandedSsid === modelData.ssid)
                              root.passwordText = text
                            }

                            onAccepted: {
                              if (text.trim().length > 0)
                              root.connectToNetwork(modelData.ssid, modelData.security, text)
                            }
                          }

                          RowLayout {
                            Layout.fillWidth: true

                            Item { Layout.fillWidth: true }

                            Button {
                              id: connectButton
                              enabled: root.passwordText.trim().length > 0
                              contentItem: Text {
                                text: "Connect"
                                color: connectButton.enabled
                                ? root.theme.on_primary
                                : Qt.alpha(root.theme.on_surface, 0.45)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                              }
                              background: Rectangle {
                                color: !connectButton.enabled
                                ? Qt.alpha(root.theme.primary, 0.28)
                                : connectButton.down
                                ? Qt.alpha(root.theme.primary, 1.00)
                                : connectButton.hovered
                                ? Qt.alpha(root.theme.primary, 0.82)
                                : Qt.alpha(root.theme.primary, 0.68)
                                radius: 6

                                opacity: connectButton.enabled ? 1.0 : 0.45

                                Behavior on color {
                                  ColorAnimation { duration: 120 }
                                }

                                Behavior on opacity {
                                  NumberAnimation { duration: 120 }
                                }

                                scale: connectButton.down ? 0.98 : (connectButton.hovered ? 1.01 : 1.0)

                                Behavior on scale {
                                  NumberAnimation { duration: 100 }
                                }

                              }

                              onClicked: {
                                root.connectToNetwork(
                                  modelData.ssid,
                                  modelData.security,
                                  root.passwordText
                                )
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
  }

  Process {
    id: wifiProc
    command: [
      "bash",
      "-c",
      "nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | awk -F: '!seen[$1]++'"
    ]

    stdout: StdioCollector {
      onStreamFinished: root.parseWifiOutput(this.text)
    }
  }

  Process {
    id: activeProc
    command: [
      "bash",
      "-c",
      "nmcli -t -f NAME connection show --active | head -n 1"
    ]

    stdout: StdioCollector {
      onStreamFinished: {
        root.activeSsid = this.text.trim()
      }
    }
  }

  Process {
    id: savedProc
    command: ["bash", "-c", "nmcli -t -f NAME,TYPE connection show | grep ':802-11-wireless' | cut -d: -f1"]
    stdout: StdioCollector {
      onStreamFinished: {
        root.savedConnections = this.text.trim().split("\n").filter(s => s.length > 0)
      }
    }
  }

  Process {
    id: connectNetwork

    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Connect stdout:", this.text)
      }
    }

    stderr: StdioCollector {
      onStreamFinished: {
        console.log("Connect stderr:", this.text)
      }
    }

    onExited: function(exitCode) {
      console.log("nmcli exited with:", exitCode)

      if (exitCode === 0) {
        root.expandedSsid = ""
        root.passwordText = ""
        root.refreshNetworks()
      }
    }
  }

  Timer {
    interval: 5000
    running: root.visible
    repeat: true
    onTriggered: root.refreshNetworks()
  }

  Component.onCompleted: root.refreshNetworks()
}
