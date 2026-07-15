import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

import ".."

Text {
    property bool muted: false

    id: root

    function getDisplayIcon() {
        if (root.muted)
            return ""
        return ""
    }

    Process {
        id: muteProc
        command: ["sh", "-c", "pactl get-source-mute @DEFAULT_SOURCE@"]
        stdout: SplitParser {
            onRead: data => {
                root.muted = data.includes("yes")
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            muteProc.running = true
        }
    }

    Component.onCompleted: {
        muteProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch('hl.dsp.exec_cmd("pavucontrol -t 4")')
        }
    }

    text: root.getDisplayIcon()
    color: Global.fontColor
    font: Global.font
}
