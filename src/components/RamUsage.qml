import QtQuick
import Quickshell.Io

import ".."

Text {
    property bool percentMode: true
    property int ramUsagePercent: 0
    property double ramUsageMem: 0.0

    id: root

    function getText() {
        var text = ""
        if (root.ramUsagePercent >= 90)
            text = " "
        else if (root.ramUsagePercent >= 60)
            text = "󰓅 "
        else if (root.ramUsagePercent >= 30)
            text = "󰾅 "
        else
            text = "󰾆 "
        return text + (root.percentMode ? (root.ramUsagePercent + "%") : (root.ramUsageMem + "GB"))
    }

    Process {
        id: ramProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                root.ramUsagePercent = Math.round(100 * used / total)
                root.ramUsageMem = Number((used / 1048576).toFixed(2))
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: ramProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.percentMode = !root.percentMode
    }

    text: root.getText()
    font: Global.globalFont
    color: Global.globalTextColor
}
