import QtQuick

import ".."

Text {
    id: root

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }

    text: ""
    color: Global.fontColor
    font: Global.font
}
