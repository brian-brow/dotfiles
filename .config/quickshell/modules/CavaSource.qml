import QtQuick
import Quickshell
import Quickshell.Io
Item {
    id: root
    visible: false   // we don't want it rendered
    width: 0
    height: 0
    property int totalBarCount: 40
    property var bars: Array(totalBarCount).fill(0)
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
