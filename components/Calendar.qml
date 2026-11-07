import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import ".."

Item {
    id: root
    implicitWidth: triggerText.implicitWidth
    implicitHeight: triggerText.implicitHeight

    Text {
        property bool datetimeMode: false
        property string datetime: ""

        id: triggerText

        function updateDatetime() {
            triggerText.datetime = Qt.formatDateTime(new Date(), triggerText.datetimeMode ? "HH:mm 󰃭 dd-MM-yyyy" : "hh:mm AP")
        }

        Component.onCompleted: triggerText.updateDatetime()

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: function () {
                triggerText.datetimeMode = !triggerText.datetimeMode
                triggerText.updateDatetime()
            }
            HoverHandler {
                id: hoverHandler
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: triggerText.updateDatetime()
        }

        text: triggerText.datetime
        font: Global.font
        color: Global.fontColor
    }


    PopupWindow {
        id: calendarPopup
        visible: hoverHandler.hovered
        anchor.item: triggerText
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        width: 260
        height: 260
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Global.backgroundColor
            radius: 10
            anchors.topMargin: 10

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatDate(new Date(), "MMMM yyyy")
                    color: Global.fontColor
                    font: Global.font
                }

                DayOfWeekRow {
                    Layout.fillWidth: true
                    locale: Qt.locale(Global.locale)
                    delegate: Text {
                        text: model.shortName
                        color: Global.fontColor
                        font: Global.font
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                MonthGrid {
                    id: grid
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    locale: Qt.locale(Global.locale)
                    month: new Date().getMonth()
                    year: new Date().getFullYear()

                    delegate: Rectangle {
                        width: 30
                        height: 30
                        color: "transparent"

                        Rectangle {
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            radius: 12
                            color: model.today ? Global.hoverColor : "transparent"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: model.date.getDate()
                            color: model.today ? Global.backgroundColor : (model.month === grid.month ? Global.fontColor : "#6c7086")
                            font.bold: model.today
                        }
                    }
                }
            }
        }
    }
}
