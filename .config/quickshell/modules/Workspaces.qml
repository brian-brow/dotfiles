import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
  id: root
  required property QtObject theme
  property int screenIndex: 0

  readonly property int wsOffset: screenIndex * 5

  spacing: 14

  Repeater {
    // model: Hyprland.workspaces.values.length < 5 ? 5 : Hyprland.workspaces.values
    model: 5

    Text {
      readonly property int workspaceId: index + 1 + root.wsOffset

      property var ws: Hyprland.workspaces.values.find(w => w.id === workspaceId)
      property bool isActive: Hyprland.focusedWorkspace?.id === (workspaceId)

      text: ""
      color: isActive
      ? theme.tertiary
      : mouse.containsMouse
      ? Qt.lighter(theme.tertiary, 1.3)
      : (ws
      ? Qt.rgba(theme.tertiary.r, theme.tertiary.g, theme.tertiary.b, 0.40)
      : Qt.rgba(theme.fg.r, theme.fg.g, theme.fg.b, 0.10))

      font.family: theme.fontFamily
      font.pixelSize: theme.fontSize
      font.bold: true
      scale: isActive ? 1.15 : 1.0

      Behavior on color {
        ColorAnimation { duration: 180 }
      }

      Behavior on scale {
        NumberAnimation {
          duration: 180
          easing.type: Easing.OutCubic
        }
      }

      MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceId} })`)
      }
    }
  }
}
