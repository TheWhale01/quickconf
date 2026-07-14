import QtQuick
import Quickshell.Io

import ".."

Text {
    property string mode: "power-saver"

    function getProfileIcon(mode) {
        if (mode == "power-saver")
            return ""
        else if (mode == "balanced")
            return ""
        return ""
    }

    function getNextMode() {
        if (mode == "power-saver")
            return "balanced"
        else if (mode == "balanced")
            return "performance"
        return "power-saver"
    }

    Process {
        id: readProc
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: data => {
                let current = data.trim()
                // Ensure we only accept valid modes just in case
                if (current === "power-saver" || current === "balanced" || current === "performance") {
                    root.mode = current
                }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: setProc
        command: []
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            let next = root.getNextMode()
            setProc.command = ["powerprofilesctl", "set", next]
            setProc.running = true
            root.mode = next
        }
    }

    id: root
    text: root.getProfileIcon(mode)
    color: Global.fontColor
    font: Global.font
}
