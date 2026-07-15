import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

import ".."

Text {
    property bool connected: false
    property int signal: 0
    readonly property var wifiIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    readonly property string disconnectedIcon: "󰤮"

    id: root

    function getWifiIcon() {
        if (!root.connected)
            return root.disconnectedIcon
        let clamped = Math.max(0, Math.min(100, root.signal))
        let index = Math.floor((clamped / 100) * (root.wifiIcons.length - 1))
        return root.wifiIcons[index]
    }

    Process {
        id: wifiProc
        command: [
            "sh", "-c",
            "iwctl station wlan0 show | grep -e 'Connected network' -we 'RSSI' | awk '/Connected network/ {print $3} /RSSI/ {print $2}' | paste -sd ':' -"
        ]
        stdout: SplitParser {
            onRead: data => {
                let d = data.trim()

                if (!d.includes(":")) {
                    root.connected = false
                    root.signal = 0
                }
                else {
                    let parts = d.split(":")
                    let dbm = parseInt(parts[1]) || -100
                    let percentage = 2 * (dbm + 100)
                    root.connected = true
                    root.signal = Math.max(0, Math.min(100, percentage))
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: wifiProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch('hl.dsp.exec_cmd("iwgtk")')
        }
    }

    Component.onCompleted: wifiProc.running = true

    text: root.getWifiIcon()
    color: Global.fontColor
    font: Global.font
}
