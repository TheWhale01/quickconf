import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

import ".."

Text {
    property bool up: true

    id: root

    Process {
        id: blueProc
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo 'yes' || echo 'no'"]
        stdout: SplitParser {
            onRead: data => {
                root.up = data.includes("yes")
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: blueProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch('hl.dsp.exec_cmd("blueman-manager")')
        }
    }

    Component.onCompleted: blueProc.running = true

    text: root.up ? "󰂯" : "󰂲"
    color: Global.fontColor
    font.weight: Global.font.weight
    font.family: Global.font.family
    font.pixelSize: 16
}
