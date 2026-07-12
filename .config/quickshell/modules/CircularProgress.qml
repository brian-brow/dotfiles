import QtQuick

Item {
    id: root

    property real value: 0
    property real lineWidth: 2
    property color progressColor: "white"
    property color trackColor: "#44ffffff"
    property color iconColor: "white"
    property string icon: ""
    property real startAngle: 90
    property int iconPixelSize: 12
    property int iconXOffset: -2
    property int iconYOffset: -1

    width: 26
    height: 26

    Behavior on value {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutCubic
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const cx = width / 2
            const cy = height / 2
            const radius = (Math.min(width, height) - root.lineWidth) / 2

            const clamped = Math.max(0, Math.min(root.value, 100))
            const start = (root.startAngle * Math.PI) / 180
            const end = start + (clamped / 100) * 2 * Math.PI

            ctx.beginPath()
            ctx.lineWidth = root.lineWidth
            ctx.strokeStyle = root.trackColor
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI, false)
            ctx.stroke()

            ctx.beginPath()
            ctx.lineWidth = root.lineWidth
            ctx.strokeStyle = root.progressColor
            ctx.lineCap = "round"
            ctx.arc(cx, cy, radius, start, end, false)
            ctx.stroke()
        }
    }

    onValueChanged: canvas.requestPaint()
    onLineWidthChanged: canvas.requestPaint()
    onProgressColorChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onStartAngleChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Text {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.iconXOffset
        anchors.verticalCenterOffset: root.iconYOffset
        width: parent.width
        height: parent.height

        text: root.icon
        color: root.iconColor
        font.pixelSize: root.iconPixelSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
