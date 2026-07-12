import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets

PanelWindow {
    id: root
    required property QtObject theme
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 200 

    // ── HOVER INTERACTION LOGIC ──────────────────────────────────────────
    property bool barHovered: false
    property bool active: barHovered || popupMouseArea.containsMouse
    visible: active || extensionClip.height > 0

    mask: Region { item: extensionClip }

    // ── BACKGROUND TRACKING ENGINE ───────────────────────────────────────
    Process {
        id: metadataStream
        command: ["sh", "-c", "playerctl metadata --format 'TITLE:{{title}}\nARTIST:{{artist}}\nALBUM:{{album}}\nARTURL:{{mpris:artUrl}}\nSTATUS:{{status}}\nLENGTH:{{mpris:length}}\nPOSITION:{{position}}' --follow"]
        running: true

        property string title: "Offline"
        property string artist: "Unknown Artist"
        property string album: "Unknown Album"
        property string artUrl: ""
        property string status: "Stopped"
        property real length: 0
        property real position: 0

        // SplitParser fires onRead once per line as it streams in,
        // unlike StdioCollector which only updates once the stream closes
        // (which never happens for a --follow'd process).
        stdout: SplitParser {
            onRead: data => {
                let line = data.trim();

                if (line.startsWith("TITLE:")) metadataStream.title = line.substring(6) || "Offline"
                else if (line.startsWith("ARTIST:")) metadataStream.artist = line.substring(7) || "Unknown Artist"
                else if (line.startsWith("ALBUM:")) metadataStream.album = line.substring(6) || "Unknown Album"
                else if (line.startsWith("ARTURL:")) {
                    let url = line.substring(7);
                    metadataStream.artUrl = url.replace("file://", "");
                }
                else if (line.startsWith("STATUS:")) metadataStream.status = line.substring(7)
                else if (line.startsWith("LENGTH:")) metadataStream.length = parseFloat(line.substring(7)) / 1000000 || 0
                else if (line.startsWith("POSITION:")) {
                    metadataStream.position = parseFloat(line.substring(9)) / 1000000 || 0
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: metadataStream.status === "Playing"
        repeat: true
        onTriggered: {
            if (metadataStream.position < metadataStream.length) {
                metadataStream.position += 1;
            }
        }
    }

    // Action execution bindings via cycling the running execution flag
    Process { id: toggleCmd; command: ["playerctl", "play-pause"] }
    Process { id: nextCmd; command: ["playerctl", "next"] }
    Process { id: prevCmd; command: ["playerctl", "previous"] }

    function formatTime(seconds) {
        if (!seconds || seconds <= 0) return "0:00";
        let mins = Math.floor(seconds / 60);
        let secs = Math.floor(seconds % 60);
        return mins + ":" + (secs < 10 ? "0" : "") + secs;
    }

    // ── SLIDING CLIPPED CONTAINER ────────────────────────────────────────
    Item {
        id: extensionClip
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 33 

        width: 440
        clip: true
        height: root.active ? 136 : 0

        Behavior on height {
            NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
        }

        // ── PLAYER PANEL BODY ────────────────────────────────────────────
        Rectangle {
            id: popupBody
            width: 440
            height: 136
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: 14
            bottomRightRadius: 14

            y: root.active ? 0 : -height

            Behavior on y {
              NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            color: Qt.rgba(root.theme.bg.r, root.theme.bg.g, root.theme.bg.b, 0.92)
            border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
            border.width: 1

            MouseArea {
              id: popupMouseArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {} 
            }

            // ── VISUAL PLAYER ROW ────────────────────────────────────────
            RowLayout {
              anchors.fill: parent
              anchors.margins: 16
              spacing: 16

              // Album Art
              ClippingRectangle {
                Layout.preferredWidth: 104
                Layout.preferredHeight: 104
                radius: 16

                color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.05)
                Image {
                  id: albumArt
                  anchors.fill: parent
                  fillMode: Image.PreserveAspectCrop
                  source: metadataStream.artUrl ? "file://" + metadataStream.artUrl : "/home/brian/Downloads/lynx2.jpg"
                  visible: status === Image.Ready

                }

              }

              // Controls Main Stack — content-sized & vertically centered
              // beside the album art, instead of force-stretched with a
              // single giant spacer eating all the slack.
              ColumnLayout {
                Layout.fillWidth: true
                spacing: 14

                Column {
                  Layout.fillWidth: true
                  spacing: 3
                  Text {
                    text: metadataStream.title
                    color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 1.0)
                    font.pixelSize: 17
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width
                  }
                  Text {
                    text: metadataStream.artist + " • " + metadataStream.album
                    color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.6)
                    font.pixelSize: 13
                    elide: Text.ElideRight
                    width: parent.width
                  }
                }

                // Progress Track — time labels flank the bar in one row,
                // instead of stacked underneath as a second row.
                RowLayout {
                  Layout.fillWidth: true
                  spacing: 10

                  Text {
                    text: root.formatTime(metadataStream.position)
                    color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.45)
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignVCenter
                  }

                  Rectangle {
                    id: progressBar
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    height: 6
                    radius: 3
                    color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.1)

                    Rectangle {
                      height: parent.height
                      radius: parent.radius
                      color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.8) 
                      width: metadataStream.length > 0 
                      ? (metadataStream.position / metadataStream.length) * parent.width 
                      : 0
                    }
                  }

                  Text {
                    text: root.formatTime(metadataStream.length)
                    color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.45)
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignVCenter
                  }
                }

                // Button Deck
                RowLayout {
                  Layout.alignment: Qt.AlignHCenter
                  spacing: 26

                  MouseArea {
                    width: 30; height: 30
                    cursorShape: Qt.PointingHandCursor
                    onClicked: prevCmd.running = true 
                    Text { text: "⏮"; font.pixelSize: 21; color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.9); anchors.centerIn: parent }
                  }

                  MouseArea {
                    width: 38; height: 38
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toggleCmd.running = true

                    Rectangle {
                      anchors.fill: parent
                      radius: width / 2
                      color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.1)

                      Text { 
                        text: metadataStream.status === "Playing" ? "⏸" : "▶"
                        font.pixelSize: 18
                        color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.9)
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: metadataStream.status === "Playing" ? 0 : 2
                      }
                    }
                  }

                  MouseArea {
                    width: 30; height: 30
                    cursorShape: Qt.PointingHandCursor
                    onClicked: nextCmd.running = true
                    Text { text: "⏭"; font.pixelSize: 21; color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.9); anchors.centerIn: parent }
                  }
                }
              }
            }
          }
        }
      }
