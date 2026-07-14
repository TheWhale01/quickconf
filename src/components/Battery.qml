import QtQuick
import Quickshell.Io

import ".."

Text {
    property string autonomy: ""
    property int percentage: 0
    property bool percentMode: true
    readonly property var icons: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

    id: root

    function getBatteryIcon() {
        let index = Math.floor((root.percentage / 100) * icons.length)

        if (index >= icons.length) {
            index = 0
        }
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

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: batProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.percentMode = !root.percentMode
    }

    text: root.percentMode ? (root.getBatteryIcon() + " " + root.percentage + "%") : (root.autonomy + " " + root.getBatteryIcon())
    color: Global.fontColor
    font: Global.font
}
