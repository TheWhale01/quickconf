import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import "./components"

PanelWindow {
    property var ramUsage: 0
    property int cpuTemp: 0

    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 25
    color: "transparent"

    RowLayout {
        anchors.leftMargin: 29
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 20

        Rectangle {
            height: root.implicitHeight
            radius: 21
            color: Global.backgroundColor
            implicitWidth: sysStats.implicitWidth + 30

            RowLayout {
                id: sysStats
                spacing: 10
                anchors.rightMargin: 20
                anchors.centerIn: parent

                CpuUsage {}
                RamUsage {}
                CpuTemp {}
            }
        }

        Rectangle {
            radius: 21
            height: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: clock.implicitWidth + 30

            RowLayout {
                id: clock
                spacing: 10
                anchors.centerIn: parent

                Text {
                    text: "test !"
                    color: "white"
                    font: Global.globalFont
                }
            }
        }
    }
}
