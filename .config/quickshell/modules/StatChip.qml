import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property QtObject theme
    required property string label
    required property string value
    property color accent: theme.fg
    property bool boldValue: true
    property bool showDivider: false

    spacing: 6

    Text {
        text: root.label + ":"
        color: root.accent

        font.family: theme.fontFamily
        font.pixelSize: theme.fontSize
        font.bold: true
    }

    Text {
        text: root.value
        color: theme.fg

        font.family: theme.fontFamily
        font.pixelSize: theme.fontSize
        font.bold: root.boldValue
    }

    Rectangle {
        visible: root.showDivider
        width: 1
        height: 16
        color: theme.muted
        Layout.leftMargin: 4
    }
}
