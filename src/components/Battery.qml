import QtQuick
import Quickshell.Io

import ".."

Text {
    property string autonomy: undefined
    property int percentage: 0
    property bool percentMode: true
    property bool plugged: false
    readonly property var icons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    id: root

    function getBatteryIcon() {
        if (root.plugged)
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
                root.plugged = data.trim().includes("on-line")
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            batProc.running = true
            plugProc.running = true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.autonomy)
                root.percentMode = !root.percentMode
            else
                root.percentMode = true
        }
    }

    text: root.percentMode ? (root.getBatteryIcon() + " " + root.percentage + "%") : (root.autonomy + " " + root.getBatteryIcon())
    color: Global.fontColor
    font: Global.font
}
