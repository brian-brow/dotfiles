import Quickshell.Io
import QtQuick

Rectangle {
    id: root
    required property QtObject theme
    required property string orientation
    readonly property bool vertical: orientation === "vertical"
    readonly property int buttonHeight: vertical ? 36 : 20
    readonly property int iconSize: vertical ? 28 : 16

    implicitHeight: buttonHeight
    implicitWidth: vertical ? 36 : label.implicitWidth + 16
    radius: vertical ? height / 3 : height / 2.5
    color: mouse.containsMouse ? theme.surface_container_high : "transparent"

    Text {
        id: label
        anchors.centerIn: parent
        text: ""
        color: mouse.containsMouse ? theme.tertiary : theme.primary
        font.family: theme.fontFamily
        font.pixelSize: root.iconSize
        font.bold: true
    }

    scale: mouse.pressed ? 0.88 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Process {
        id: scriptProc
        command: ["bash", "-c", "wlogout"]
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: scriptProc.running = true
    }
}
