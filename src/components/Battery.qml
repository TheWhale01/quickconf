import QtQuick
import Quickshell.Io

import ".."
import "states"

Text {
    property string autonomy: ""
    property int percentage: 0
    readonly property var icons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    id: root

    function getBatteryIcon() {
        if (BatteryState.plugged)
            return ""
        let clamped = Math.max(0, Math.min(100, root.percentage))
        let index = Math.floor((clamped / 100) * (icons.length - 1))
        return root.icons[index]
    }

    Process {
        id: batProc
        command: ["sh", "-c", "acpi -b"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(/\s+/)
                root.percentage = parseInt(parts[3])
                root.autonomy = Qt.formatTime(new Date("1970-01-01T" + parts[4]), "HH 'h' mm 'min'")
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: plugProc
        command: ["sh", "-c", "acpi -a"]
        stdout: SplitParser {
            onRead: data => {
                BatteryState.plugged = data.trim().includes("on-line")
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            plugProc.running = true
            batProc.running = true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (BatteryState.plugged && root.percentage == 100)
                BatteryState.percentMode = true
            else
                BatteryState.percentMode = !BatteryState.percentMode
        }
    }

    text: BatteryState.percentMode ? (root.getBatteryIcon() + " " + root.percentage + "%") : (root.autonomy + " " + root.getBatteryIcon())
    color: Global.fontColor
    font: Global.font
}
