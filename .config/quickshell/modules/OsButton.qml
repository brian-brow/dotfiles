import Quickshell.Io
import QtQuick

Rectangle {
    id: root
    required property QtObject theme

    implicitHeight: 20
    implicitWidth: label.implicitWidth + 16
    radius: height / 2
    color: mouse.containsMouse ? theme.bg : theme.primary

    Text {
        id: label
        anchors.centerIn: parent
        text: ""
        color: mouse.containsMouse ? theme.tertiary : theme.bg
        font.family: theme.fontFamily
        font.pixelSize: 16
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
        command: ["bash", "-c", "pgrep rofi >/dev/null 2>&1 && killall rofi || rofi -show drun"]
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: scriptProc.running = true
    }
}
