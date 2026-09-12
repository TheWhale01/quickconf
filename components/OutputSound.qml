import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

import ".."

Text {
    property int level: 0
    property bool muted: false
    property string type: ""
    readonly property var specificIcons: {
        "headphone": " ",
        "hands-free": " ",
        "headset": " ",
        "phone": " ",
        "portable": " ",
        "car": " ",
    }
    readonly property var defaultIcons: [" ", " ", " "]
    readonly property string mutedIcon: "󰖁 "

    id: root

    function getDisplayIcon() {
        if (root.muted)
            return root.mutedIcon
        let icon = root.specificIcons[root.type]
        if (icon)
            return icon
        let clamped = Math.max(0, Math.min(100, root.level))
        let index = Math.floor((clamped / 100) * (root.defaultIcons.length - 1))
        return root.defaultIcons[index]
    }

    Process {
        id: sinkTypeProc
        command: ["sh", "-c", "pactl list sinks | grep -A 30 \"$(pactl get-default-sink)\" | grep \"device.form_factor\" | cut -d '\"' -f 2 | head -n 1"]
        stdout: SplitParser {
            onRead: data => {
                root.type = data.trim()
            }
        }
    }

    Process {
        id: muteProc
        command: ["sh", "-c", "pactl get-sink-mute @DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                root.muted = data.includes("yes")
            }
        }
    }

    Process {
        id: levelProc
        command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo '[0-9]+%' | head -n 1 | tr -d '%'"]
        stdout: SplitParser {
            onRead: data => {
                root.level = parseInt(data.trim()) || 0
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            levelProc.running = true
            sinkTypeProc.running = true
            muteProc.running = true
        }
    }

    Component.onCompleted: {
        levelProc.running = true
        sinkTypeProc.running = true
        muteProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch('hl.dsp.exec_cmd("pavucontrol -t 3")')
        }
    }

    text: root.getDisplayIcon() + root.level
    color: Global.fontColor
    font: Global.font
}
