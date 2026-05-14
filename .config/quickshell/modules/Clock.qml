import QtQuick

Text {
    id: root

    required property QtObject theme
    property string format: "hh:mm AP"

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
