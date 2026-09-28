import QtQuick

Text {
    id: root

    required property QtObject theme
    required property string orientation

    readonly property bool vertical: orientation === "vertical"

    property string format: vertical ? "HH\nmm" : "hh:mm AP"


    color: theme.fg

    font.family: theme.fontFamily
    font.pixelSize: theme.fontSize
    font.bold: true

    text: Qt.formatDateTime(new Date(), format)

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatDateTime(new Date(), root.format)
    }
}
