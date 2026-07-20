import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Services.Pipewire

PanelWindow {
  id: root
  required property QtObject theme
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 340
  // ── HOVER INTERACTION LOGIC ──────────────────────────────────────────
  property bool barHovered: false
  property bool active: barHovered || popupHover.hovered
  visible: active
  mask: Region { item: popupBody }
  // ── PANEL BODY ──────────────────────────────────────────────────
  Rectangle {
    id: popupBody
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 33
    width: 440
    height: 300
    radius: 14
    color: Qt.rgba(root.theme.bg.r, root.theme.bg.g, root.theme.bg.b, 0.92)
    border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
    border.width: 1
    HoverHandler {
      id: popupHover
    }
    MouseArea {
      id: popupMouseArea
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {}
    }

    // ── CALENDAR (top-left, 50% width / 60% height) ─────────────
    Rectangle {
      id: calendarCard
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.margins: 8
      anchors.bottom: slidersCard.top
      anchors.bottomMargin: 8
      width: parent.width * 0.5 - 8
      radius: 10
      color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.05)
      border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
      border.width: 1
      MouseArea {
        id: calendarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {}
      }
      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 3
        Text {
          text: Qt.formatDate(new Date(), "MMMM yyyy")
          color: "white"
          font.pixelSize: 14
          font.bold: true
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
        }
        GridLayout {
          columns: 1
          DayOfWeekRow {
            locale: grid.locale
            Layout.column: 1
            Layout.fillWidth: true
            delegate: Text {
              text: model.shortName
              color: "white"
              horizontalAlignment: Text.AlignHCenter
              required property var model
            }
          }
          MonthGrid {
            id: grid
            month: new Date().getMonth()
            year: new Date().getFullYear()
            locale: Qt.locale("en_US")
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Item {
              required property var model
              implicitWidth: 32
              implicitHeight: 32

              Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 20
                radius: 4
                visible: true
                color: model.today ? root.theme.primary : "transparent"
              }

              Text {
                anchors.centerIn: parent
                opacity: model.month === grid.month ? 1 : 0.5
                text: model.day
                font.pixelSize: 14
                color: model.today ? root.theme.on_primary : "white"
              }
            }
          }
        }
      }
    }

    // ── QUICK ACTION BUTTONS (top-right, remaining space) ────────
    Item {
      id: quickActionsColumn
      anchors.top: parent.top
      anchors.topMargin: 8
      anchors.left: calendarCard.right
      anchors.leftMargin: 8
      anchors.right: parent.right
      anchors.rightMargin: 8
      anchors.bottom: slidersCard.top
      anchors.bottomMargin: 8

      Rectangle {
        id: weatherCard
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: (parent.height - 8) * 2 / 3
        radius: 10
        color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.05)
        border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
        border.width: 1

        property string temperature: "92°F"
        property string condition: "Cloudy"

        function refreshWeather() {
          weatherProc.running = false
          weatherProc.running = true
        }

        Process {
          id: weatherProc
          command: ["bash", "-c", "curl -s 'https://wttr.in/?format=%t+%C&u'"]

          stdout: SplitParser {
            onRead: data => {
              const text = data.trim()
              if (!text)
              return

              const parts = text.split(" ")
              weatherCard.temperature = parts[0] || weatherCard.temperature
              weatherCard.condition = parts.slice(1).join(" ") || weatherCard.condition
            }
          }
        }

        Timer {
          interval: 300000
          running: false
          repeat: false
          onTriggered: weatherCard.refreshWeather()
        }

        Component.onCompleted: weatherCard.refreshWeather()

        Column {
          anchors.centerIn: parent
          spacing: 2

          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: weatherCard.temperature
            color: "white"
            font.family: root.theme.fontFamily
            font.pixelSize: 40
            font.bold: true
          }

          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: weatherCard.condition
            color: Qt.rgba(1, 1, 1, 0.6)
            font.family: root.theme.fontFamily
            font.pixelSize: 25
          }
        }
      }

      GridLayout {
        id: quickActionsGrid
        anchors.top: weatherCard.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columns: 2
        columnSpacing: 8

        Repeater {
          model: 2

          Rectangle {
            id: quickButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            property bool flashing: false
            color: quickButton.flashing
            ? Qt.rgba(0, 0, 0, 0.25)
            : quickButtonMouseArea.containsMouse
            ? Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
            : Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.05)
            border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
            border.width: 1

            Behavior on color {
              ColorAnimation { duration: 120 }
            }

            // Button 1 opens the wallpaper picker; the rest are placeholders — drop a command in here later
            Process {
              id: quickButtonProc
              command: index === 0 ? ["qs", "ipc", "call", "wallpaper", "open"]
                      : index === 1 ? ["qs", "ipc", "call", "8ball", "open"] : []
            }

            Timer {
              id: quickButtonFlashTimer
              interval: 150
              onTriggered: quickButton.flashing = false
            }

            Text {
              anchors.centerIn: parent
              text: index === 0 ? "" : "󰲮"
              color: "white"
              font.family: root.theme.fontFamily
              font.pixelSize: index === 0 ? 32 : 48
            }

            MouseArea {
              id: quickButtonMouseArea
              anchors.fill: parent
              hoverEnabled: true
              onClicked: {
                quickButton.flashing = true
                quickButtonFlashTimer.restart()
                quickButtonProc.running = false
                quickButtonProc.running = true
              }
            }
          }
        }
      }
    }

    PwObjectTracker {
      objects: [ Pipewire.defaultAudioSink ]
    }

    // ── SLIDERS CARD (background behind brightness/volume rows) ─
    Rectangle {
      id: slidersCard
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 8
      anchors.rightMargin: 8
      anchors.top: brightnessIcon.top
      anchors.topMargin: -8
      anchors.bottom: volumeSlider.bottom
      anchors.bottomMargin: -8
      radius: 10
      color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.05)
      border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.08)
      border.width: 1
    }

    // ── VOLUME ICON ─────────────────────────────────
    Text {
      id: volumeIcon
      anchors.left: parent.left
      anchors.leftMargin: 16
      anchors.verticalCenter: volumeSlider.verticalCenter
      width: 20
      horizontalAlignment: Text.AlignHCenter
      font.family: root.theme.fontFamily
      font.pixelSize: 14
      color: root.theme.fg

      readonly property var sink: Pipewire.defaultAudioSink

      function isBluetoothSink(sink) {
        if (!sink) return false

        const name = (sink.name || "").toLowerCase()
        const desc = (sink.description || "").toLowerCase()

        return name.includes("bluez") || desc.includes("bluetooth")
      }

      text: sink?.audio?.muted
      ? "󰝟"
      : isBluetoothSink(sink)
      ? ""
      : ""
    }

    // ── VOLUME SLIDER (bottom row) ─────────────────
    Slider {
      id: volumeSlider
      anchors.left: volumeIcon.right
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.leftMargin: 8
      anchors.rightMargin: 16
      anchors.bottomMargin: 16
      height: 24
      from: 0
      to: 100

      readonly property var sink: Pipewire.defaultAudioSink

      // Only sync FROM pipewire when the user isn't actively dragging
      Connections {
        target: volumeSlider.sink?.audio ?? null
        function onVolumeChanged() {
          if (!volumeSlider.pressed)
          volumeSlider.value = volumeSlider.sink.audio.volume * 100
        }
      }

      // Set initial value once the sink/audio becomes available
      Component.onCompleted: {
        if (sink?.ready && sink.audio)
        value = sink.audio.volume * 100
      }

      // Push value TO pipewire as the user drags
      onMoved: {
        if (sink?.ready && sink.audio) {
          sink.audio.volume = value / 100
        }
      }

      background: Rectangle {
        x: volumeSlider.leftPadding
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        width: volumeSlider.availableWidth
        height: 8
        radius: 4
        color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.1)

        Rectangle {
          width: volumeSlider.visualPosition * parent.width
          height: parent.height
          radius: parent.radius
          color: root.theme.primary
        }
      }

      handle: Rectangle {
        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        width: 16
        height: 16
        radius: width / 2
        color: "white"
        border.color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.2)
        border.width: 1
      }
    }

    // ── BRIGHTNESS ICON ─────────────────────────────
    Text {
      id: brightnessIcon
      anchors.left: parent.left
      anchors.leftMargin: 16
      anchors.verticalCenter: brightnessSlider.verticalCenter
      width: 20
      horizontalAlignment: Text.AlignHCenter
      font.family: root.theme.fontFamily
      font.pixelSize: 14
      color: root.theme.fg

      text: brightnessSlider.value < 33 ? "󰃞"
      : brightnessSlider.value < 66 ? "󰃟"
      : "󰃠"
    }

    // ── BRIGHTNESS SLIDER (row above volume) ───────
    Slider {
      id: brightnessSlider
      anchors.left: brightnessIcon.right
      anchors.right: parent.right
      anchors.bottom: volumeSlider.top
      anchors.leftMargin: 8
      anchors.rightMargin: 16
      anchors.bottomMargin: 8
      height: 24
      from: 0
      to: 100

      function refreshBrightness() {
        brightnessProc.running = false
        brightnessProc.running = true
      }

      // Only sync FROM brightnessctl when the user isn't actively dragging
      Process {
        id: brightnessProc
        command: ["bash", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]

        stdout: SplitParser {
          onRead: data => {
            const n = parseInt(data.trim())
            if (!isNaN(n) && !brightnessSlider.pressed)
            brightnessSlider.value = n
          }
        }
      }
      Process {
        id: brightnessSetProc
      }

      Timer {
        interval: 120
        running: true
        repeat: true
        onTriggered: brightnessSlider.refreshBrightness()
      }

      Component.onCompleted: refreshBrightness()

      // Push value TO brightnessctl as the user drags
      onMoved: {
        brightnessSetProc.command = ["bash", "-c", `brightnessctl set ${Math.round(value)}%`]
        brightnessSetProc.running = false
        brightnessSetProc.running = true
      }

      background: Rectangle {
        x: brightnessSlider.leftPadding
        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
        width: brightnessSlider.availableWidth
        height: 8
        radius: 4
        color: Qt.rgba(root.theme.fg.r, root.theme.fg.g, root.theme.fg.b, 0.1)

        Rectangle {
          width: brightnessSlider.visualPosition * parent.width
          height: parent.height
          radius: parent.radius
          color: root.theme.primary
        }
      }

      handle: Rectangle {
        x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
        width: 16
        height: 16
        radius: width / 2
        color: "white"
      }
    }
  }
}
