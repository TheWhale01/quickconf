import QtQuick
import Quickshell.Io

import ".."
import "states"

Text {
    id: root

    function getProfileIcon(mode) {
        if (mode == "powersave")
            return ""
        else if (mode == "balanced")
            return ""
        return ""
    }

    function getNextMode() {
        if (PowerProfilesState.mode == "powersave")
            return "balanced"
        else if (PowerProfilesState.mode == "balanced")
            return "throughput-performance"
        return "powersave"
    }

    Process {
        id: readProc
        command: ["tuned-adm", "active"]
        stdout: SplitParser {
            onRead: data => {
                let current = data.trim().replace('Current active profile: ', '')
                if (current === "powersave" || current === "balanced" || current === "throughput-performance") {
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

            setProc.command = ["tuned-adm", "profile", next]
            setProc.running = true
            PowerProfilesState.mode = next
        }
    }

    text: root.getProfileIcon(PowerProfilesState.mode)
    color: Global.fontColor
    font: Global.font
}
