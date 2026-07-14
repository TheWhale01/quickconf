import QtQuick
import QtQuick.Window
import Quickshell.Wayland

import ".."

Text {
    property bool active: false

    id: root

    IdleInhibitor {
        id: inhibitor
        window: root.Window.window
        enabled: root.active
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.active = !root.active
    }

    text: active ? "󰅶" : "󰛊"
    color: Global.fontColor
    font: Global.font
}
