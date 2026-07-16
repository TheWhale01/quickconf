import QtQuick
import Quickshell.Io

import ".."
import "states"

Text {
    id: root

    function getProfileIcon(mode) {
        if (mode == "power-saver")
            return ""
        else if (mode == "balanced")
            return ""
        return ""
    }

    function getNextMode() {
        if (PowerProfilesState.mode == "power-saver")
            return "balanced"
        else if (PowerProfilesState.mode == "balanced")
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
                    PowerProfilesState.mode = current
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
            PowerProfilesState.mode = next
        }
    }

    text: root.getProfileIcon(PowerProfilesState.mode)
    color: Global.fontColor
    font: Global.font
}
