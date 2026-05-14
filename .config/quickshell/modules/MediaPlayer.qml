import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
  id: root

  required property QtObject theme

  property string scriptPath: "/home/brian/.config/quickshell/scripts/music_info"

  property string song: "Offline"
  property string artist: "Offline"
  property string coverPath: "/home/brian/.config/quickshell/assets/default-artwork.png"
  property bool playing: false

  property int progress: 0
  property string positionFormatted: "0:00"
  property string lengthFormatted: "0:00"

  property bool hovered: false

  property color songColor: root.theme.fg
  property color artistColor: Qt.alpha(root.theme.fg, 0.7)
  property color controlColor: root.theme.fg

  property int songFontSize: 11
  property int artistFontSize: 10
  property int controlFontSize: 24

  width: 180
  height: 28

  function refreshAll() {
    songProc.running = false
    artistProc.running = false
    coverProc.running = false
    progressProc.running = false
    positionProc.running = false
    lengthProc.running = false
    statusProc.running = false

    songProc.running = true
    artistProc.running = true
    coverProc.running = true
    progressProc.running = true
    positionProc.running = true
    lengthProc.running = true
    statusProc.running = true
  }

  function togglePlayback() {
    toggleProc.running = false
    toggleProc.running = true
    delayedRefresh.restart()
  }

  function nextTrack() {
    nextProc.running = false
    nextProc.running = true
    delayedRefresh.restart()
  }

  function prevTrack() {
    prevProc.running = false
    prevProc.running = true
    delayedRefresh.restart()
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 6
    anchors.rightMargin: 6
    spacing: 8

    Rectangle {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20
      Layout.alignment: Qt.AlignVCenter
      radius: 4
      color: Qt.alpha(root.theme.fg, 0.10)
      clip: true

      Image {
        anchors.fill: parent
        source: root.coverPath
        fillMode: Image.PreserveAspectCrop
        cache: false
        asynchronous: true
      }
    }

    Item {
      id: contentSwitcher
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      height: 20
      clip: true

      Item {
        id: textView
        anchors.fill: parent
        opacity: root.hovered ? 0 : 1
        x: root.hovered ? -12 : 0

        Behavior on opacity {
          NumberAnimation { duration: 140 }
        }

        Behavior on x {
          NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
          }
        }

        Item {
          anchors.fill: parent

          Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: -1
            text: root.song
            color: root.songColor
            font.pixelSize: root.songFontSize
            elide: Text.ElideRight
          }

          Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: root.songFontSize
            text: root.artist
            color: root.artistColor
            font.pixelSize: root.artistFontSize
            elide: Text.ElideRight
          }
        }
      }

      RowLayout {
        id: controlsView
        anchors.fill: parent
        spacing: 20
        opacity: root.hovered ? 1 : 0
        x: root.hovered ? 0 : 12

        Behavior on opacity {
          NumberAnimation { duration: 140 }
        }

        Behavior on x {
          NumberAnimation {
            duration: 160
            easing.type: Easing.OutCubic
          }
        }

        Item { Layout.fillWidth: true }

        Item {
          width: root.controlFontSize
          height: root.controlFontSize
          Layout.alignment: Qt.AlignVCenter

          Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            anchors.horizontalCenterOffset: -10
            text: "󰒮"
            color: root.controlColor
            font.pixelSize: root.controlFontSize
            scale: root.hovered ? 1.0 : 0.80

            Behavior on scale {
              NumberAnimation { duration: 120 }
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.prevTrack()
          }
        }

        Item {
          width: root.controlFontSize
          height: root.controlFontSize
          Layout.alignment: Qt.AlignVCenter

          Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            anchors.horizontalCenterOffset: -10
            text: root.playing ? "󰏤" : "󰐊"
            color: root.controlColor
            font.pixelSize: root.controlFontSize
            scale: root.hovered ? 1.0 : 0.95

            Behavior on scale {
              NumberAnimation { duration: 120 }
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.togglePlayback()
          }
        }

        Item {
          width: root.controlFontSize
          height: root.controlFontSize
          Layout.alignment: Qt.AlignVCenter

          Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            anchors.horizontalCenterOffset: -10
            text: "󰒭"
            color: root.controlColor
            font.pixelSize: root.controlFontSize
            scale: root.hovered ? 1.0 : 0.95

            Behavior on scale {
              NumberAnimation { duration: 120 }
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.nextTrack()
          }
        }

        Item { Layout.fillWidth: true }
      }
    }
  }

  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 2
    radius: 1
    color: Qt.alpha(root.theme.fg, 0.12)

    Rectangle {
      width: parent.width * (root.progress / 100)
      height: parent.height
      radius: 1
      color: root.theme.primary

      Behavior on width {
        NumberAnimation { duration: 180 }
      }
    }
  }

  Process {
    id: songProc
    command: ["bash", "-c", `${root.scriptPath} --song`]
    stdout: SplitParser {
      onRead: data => root.song = data.trim()
    }
  }

  Process {
    id: artistProc
    command: ["bash", "-c", `${root.scriptPath} --artist`]
    stdout: SplitParser {
      onRead: data => root.artist = data.trim()
    }
  }

  Process {
    id: coverProc
    command: ["bash", "-c", `${root.scriptPath} --cover`]
    stdout: SplitParser {
      onRead: data => root.coverPath = data.trim()
    }
  }

  Process {
    id: progressProc
    command: ["bash", "-c", `${root.scriptPath} --progress`]
    stdout: SplitParser {
      onRead: data => {
        const n = parseInt(data.trim())
        if (!isNaN(n))
          root.progress = n
      }
    }
  }

  Process {
    id: positionProc
    command: ["bash", "-c", `${root.scriptPath} --position-formatted`]
    stdout: SplitParser {
      onRead: data => root.positionFormatted = data.trim()
    }
  }

  Process {
    id: lengthProc
    command: ["bash", "-c", `${root.scriptPath} --length-formatted`]
    stdout: SplitParser {
      onRead: data => root.lengthFormatted = data.trim()
    }
  }

  Process {
    id: statusProc
    command: ["bash", "-c", "playerctl status 2>/dev/null"]
    stdout: SplitParser {
      onRead: data => root.playing = data.trim() === "Playing"
    }
  }

  Process {
    id: toggleProc
    command: ["bash", "-c", `${root.scriptPath} --toggle`]
  }

  Process {
    id: nextProc
    command: ["bash", "-c", `${root.scriptPath} --next`]
    stdout: SplitParser {
      onRead: data => {
        const p = data.trim()
        if (p.length > 0)
          root.coverPath = p
      }
    }
  }

  Process {
    id: prevProc
    command: ["bash", "-c", `${root.scriptPath} --prev`]
    stdout: SplitParser {
      onRead: data => {
        const p = data.trim()
        if (p.length > 0)
          root.coverPath = p
      }
    }
  }

  Timer {
    id: pollTimer
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.refreshAll()
  }

  Timer {
    id: delayedRefresh
    interval: 400
    repeat: false
    onTriggered: root.refreshAll()
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    onEntered: root.hovered = true
    onExited: root.hovered = false
  }

  Component.onCompleted: refreshAll()
}
