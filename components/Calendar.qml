import QtQuick
import QtQuick.Window

import ".."

Text {
    property bool datetimeMode: false
    property string datetime: ""

    id: root

    function updateDatetime() {
        root.datetime = Qt.formatDateTime(new Date(), root.datetimeMode ? "HH:mm 󰃭 dd-MM-yyyy" : "hh:mm AP")
    }

    Component.onCompleted: root.updateDatetime()

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.datetimeMode = !root.datetimeMode
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateDatetime()
    }

    text: root.datetime
    color: Global.fontColor
    font: Global.font
}
