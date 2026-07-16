import Quickshell
import Quickshell.Wayland
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
      anchors.margins: 16
      width: parent.width * 0.5 - 16
      height: parent.height * 0.7 - 16
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

    PwObjectTracker {
      objects: [ Pipewire.defaultAudioSink ]
    }

    // ── VOLUME SLIDER (bottom row) ─────────────────
    Slider {
      id: volumeSlider
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.leftMargin: 16
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

    // ── BRIGHTNESS SLIDER (row above volume) ───────
    Slider {
      id: brightnessSlider
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: volumeSlider.top
      anchors.leftMargin: 16
      anchors.rightMargin: 16
      anchors.bottomMargin: 8
      height: 24
      from: 0
      to: 100
      value: 50

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
