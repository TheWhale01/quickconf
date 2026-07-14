import QtQuick
import Quickshell.Io

import ".."

Text {
    property int maxBrightness: 0
    property int currentBrightness: 0
    property int currentPercent: 0
    readonly property var icons: ["", "", "", "", "", "", "", "", ""]

    id: root

    function getBrightnessIcon() {
        let clamped = Math.max(0, Math.min(100, root.currentPercent))
        let index = Math.floor((clamped / 100) * (icons.length - 1))
        return root.icons[index]
    }

    Process {
        id: maxBrightProc
        command: ["sh", "-c", "brightnessctl max"]
        stdout: SplitParser {
            onRead: data => {
                root.maxBrightness = parseInt(data)
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: currentBrightProc
        command: ["sh", "-c", "brightnessctl get"]
        stdout: SplitParser {
            onRead: data => {
                root.currentBrightness = parseInt(data.trim())
                root.currentPercent = Math.round((root.currentBrightness / root.maxBrightness) * 100)
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentBrightProc.running = true
    }

    text: root.getBrightnessIcon() + " " + root.currentPercent + "%"
    color: Global.fontColor
    font: Global.font
}
