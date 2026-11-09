import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import ".."

Item {
    property bool clicked: false

    id: root
    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    Text {
        id: text

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked = true
        }

        text: ""
        color: Global.fontColor
        font: Global.font
    }

    PopupWindow {
        visible: root.clicked
    }
}
