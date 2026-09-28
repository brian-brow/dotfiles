import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "."

Item {
  id: root

  required property QtObject theme

  readonly property var sink: Pipewire.defaultAudioSink

  implicitWidth: 24
  implicitHeight: 24

  function isBluetoothSink(sink) {
    if (!sink) return false

    const name = (sink.name || "").toLowerCase()
    const desc = (sink.description || "").toLowerCase()

    return name.includes("bluez") || desc.includes("bluetooth")
  }

  function iconForState() {
    if (!root.sink) return "󱄡"
    if (root.sink.audio.muted) return ""
    if (root.sink.audio.volume * 100 < 25) return ""
    if (root.sink.audio.volume * 100 < 50) return ""
    if (root.sink.audio.volume * 100 < 75) return ""
    return ""
  }

  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  Text {
    anchors.centerIn: parent
    text: root.iconForState()
    color: root.sink?.audio?.muted
    ? theme.primary
    : theme.tertiary
    font.family: theme.fontFamily
    font.pixelSize: 24
    font.bold: true
  }

  MouseArea {
    anchors.fill: parent
    onWheel: wheel => {
      if (!root.sink?.audio) return
      const delta = wheel.angleDelta.y > 0 ? 0.01 : -0.01
      root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + delta))
    }
    onClicked: {
      Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
    }
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

  }
}
