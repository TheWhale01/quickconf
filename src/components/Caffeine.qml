import QtQuick
import QtQuick.Window
import Quickshell.Wayland

import ".."
import "states"

Text {
    id: root

    IdleInhibitor {
        id: inhibitor
        window: root.Window.window
        enabled: CaffeineState.active
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: CaffeineState.active = !CaffeineState.active
    }

    text: CaffeineState.active ? "󰅶" : "󰛊"
    color: Global.fontColor
    font: Global.font
}
