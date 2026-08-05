import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "."

CircularProgress {
  id: root

  required property QtObject theme

  readonly property var sink: Pipewire.defaultAudioSink

  function isBluetoothSink(sink) {
    if (!sink) return false

    const name = (sink.name || "").toLowerCase()
    const desc = (sink.description || "").toLowerCase()

    return name.includes("bluez") || desc.includes("bluetooth")
  }

  value: root.sink?.audio ? root.sink.audio.volume * 100 : 0
  lineWidth: 2
  progressColor: theme.primary
  trackColor: Qt.alpha(theme.primary, 0.25)
  iconColor: theme.fg

  icon: root.sink?.audio?.muted
  ? "󰝟"
  : isBluetoothSink(root.sink)
  ? ""
  : ""

  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
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
