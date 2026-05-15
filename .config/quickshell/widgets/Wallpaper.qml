import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects

PanelWindow {
  id: root

  required property QtObject theme

  visible: false
  focusable: true

  width: 1000
  height: 500
  color: "transparent"


  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

  property var filteredWallpapers: []

  Process {
    id: setWallpaper
    command: ["bash", "-c",
      "SYMLINK_PATH=/home/brian/.config/hypr/current_wallpaper; " +
      "mkdir -p \"$(dirname $SYMLINK_PATH)\"; " +
      "ln -sf \"$SELECTED_PATH\" \"$SYMLINK_PATH\"; " +
      "RANDOM_X=$((RANDOM % 1920)); RANDOM_Y=$((RANDOM % 1080)); " +
      "awww img \"$SELECTED_PATH\" --transition-type outer --transition-duration 2 --transition-pos $RANDOM_X,$RANDOM_Y && " +
      "matugen image \"$SELECTED_PATH\" --mode dark --source-color-index 0"
    ]
    environment: ({"SELECTED_PATH": root.selectedPath})
    running: false
  }

  property string selectedPath: ""

  Process {
    id: wallpaperList
    command: ["bash", "-c", "ls -t /home/brian/Wallpapers/*.jpg /home/brian/Wallpapers/*.png /home/brian/Wallpapers/*.gif /home/brian/Wallpapers/*.jpeg 2>/dev/null | shuf"]
    running: false
    stdout: SplitParser {
      onRead: data => {
        allWallpapers.push(data)
        allWallpapersChanged()
        if (wallpapers.length < 25) {
          wallpapers.push(data)
          wallpapersChanged()
          root.filteredWallpapers = root.wallpapers.slice()
        }
      }
    }
  }

  property var wallpapers: []
  property var allWallpapers: []
  property string previewSource: "/home/brian/.config/hypr/current_wallpaper"

  onVisibleChanged: {
    if (visible) {
      wallpapers = []
      allWallpapers = []
      previewSource = "/home/brian/.config/hypr/current_wallpaper"
      wallpaperList.running = true
      textinput.text = ""
      textinput.forceActiveFocus()
    }
  }

  FileView {
    id: dirView
    path: "/home/brian/Wallpapers"
  }

  Rectangle {
    id: win
    anchors.fill: parent
    radius: 14
    color: root.theme.bg
    border.width: 1
    border.color: Qt.alpha(root.theme.fg, 0.12)
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskThresholdMin: 0.5
      maskSpreadAtMin: 1.0
      maskSource: ShaderEffectSource {
        sourceItem: mask
      }
    }

    Item {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      width: parent.width / 2

      Image {
        anchors.fill: parent
        anchors.margins: 1
        source: root.previewSource
        fillMode: Image.PreserveAspectCrop
      }

      Item {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 24
        height: 48

        Rectangle {
          anchors.fill: parent
          radius: 8
          color: root.theme.fg
          border.width: 1
          border.color: Qt.alpha(root.theme.fg, 0.2)
        }

        Text {
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
          leftPadding: 16
          text: "󰍉"
          font.family: "JetBrains Mono Nerd Font"
          font.pixelSize: 16
          color: Qt.alpha(root.theme.bg, 0.5)
          z: 1
        }
        TextField {
          id: textinput
          anchors.fill: parent
          topPadding: 0
          bottomPadding: 0
          leftPadding: 40
          rightPadding: 12
          placeholderText: "Search"
          font.family: "JetBrains Mono Nerd Font"
          font.pixelSize: 16
          color: Qt.alpha(root.theme.bg, 0.5)
          Keys.onEscapePressed: root.visible = false
          verticalAlignment: TextInput.AlignVCenter
          background: Rectangle {
            color: root.theme.fg
            radius: 8
            border.width: 1
            border.color: Qt.alpha(root.theme.fg, 0.2)
          }
          onTextChanged: {
            if (text === "") {
              root.filteredWallpapers = root.wallpapers
            } else {
              root.filteredWallpapers = root.allWallpapers.filter(path => {
                const filename = path.split("/").pop().toLowerCase()
                const query = text.toLowerCase()
                let qi = 0
                for (let i = 0; i < filename.length && qi < query.length; i++) {
                  if (filename[i] === query[qi]) qi++
                }
                return qi === query.length
              })
              root.previewSource = root.filteredWallpapers[0]
            }
          }
          onAccepted: {
            if (textinput.text == "") {
              root.selectedPath = wallpapers[Math.floor(Math.random() * wallpapers.length)]
              root.previewSource = root.selectedPath
            } else {
              root.selectedPath = root.filteredWallpapers[0]
            }

            setWallpaper.running = false
            setWallpaper.running = true
            root.visible = false
            console.log(wallpapers[Math.floor(Math.random() * wallpapers.length)])
            console.log(textinput.text)
            console.log("wallpapers length:", wallpapers.length)
            console.log("selected path:", root.selectedPath)
            console.log("preview source:", root.previewSource)
          }
        }
      }
    }

    Flow {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 0
      width: parent.width / 2
      // padding: 6
      leftPadding: 16
      topPadding: 17
      spacing: 4
      Repeater {
        // Rectangle {
        //   color: root.theme.fg
        // }
        model: filteredWallpapers
        delegate: Item {
          width: 90
          height: 90

          Image {
            id: thumbImg
            anchors.fill: parent
            source: modelData
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            mipmap: true
            visible: false
          }

          Rectangle {
            id: thumbMask
            anchors.fill: parent
            radius: 6
            visible: false
          }

          OpacityMask {
            anchors.fill: parent
            source: thumbImg
            maskSource: thumbMask
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
              root.previewSource = modelData
              parent.scale = 1.05
            }
            onClicked: {
              root.selectedPath = modelData
              setWallpaper.running = false
              setWallpaper.running = true
              root.visible = false
            }
            onExited: parent.scale = 1.0
            onPressed: parent.scale = 0.92
            onReleased: parent.scale = 1.0
          }

          Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
          }
        }
      }
    }

    Rectangle {
      id: mask
      anchors.fill: win
      radius: win.radius
      visible: false
    }
  }
}
