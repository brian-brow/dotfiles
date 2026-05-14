import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    required property QtObject theme

    property int totalBarCount: 40
    property int visibleBarCount: 20
    property int startIndex: 0
    property bool mirror: false

    property var bars: Array(totalBarCount).fill(0)

    Row {
        anchors.fill: parent
        spacing: 2

        Repeater {
            model: root.visibleBarCount

            Rectangle {
                width: (root.width - ((root.visibleBarCount - 1) * 2)) / root.visibleBarCount
                height: Math.max(
                    2,
                    (
                        root.bars[
                            root.mirror
                                ? (root.startIndex + (root.visibleBarCount - 1 - index))
                                : (root.startIndex + index)
                        ] / 100
                    ) * root.height
                )
                radius: 1
                color: root.theme.primary
                anchors.bottom: parent.bottom
            }
        }
    }

    function updateBars(frame) {
        const values = frame.trim().split(";")
        if (values.length < root.totalBarCount)
            return

        let next = []
        for (let i = 0; i < root.totalBarCount; ++i) {
            const n = parseInt(values[i])
            next.push(isNaN(n) ? 0 : n)
        }
        root.bars = next
    }

    Process {
        id: cavaProc
        command: ["cava"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => root.updateBars(data)
        }

        running: true
    }
}
