import QtQuick
import Quickshell
import QtQuick.Layouts

import "./components"

PanelWindow {
    property int space: 20
    property int radius: 21
    property int spaceOffset: 30
    property int interSpace: 10

    id: root
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "transparent"

    RowLayout {
        anchors.leftMargin: root.spaceOffset
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: root.space

        Rectangle {
            radius: root.radius
            implicitHeight: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: sysStats.implicitWidth + root.spaceOffset

            RowLayout {
                id: sysStats
                spacing: root.interSpace
                anchors.centerIn: parent

                CpuUsage {}
                RamUsage {}
                CpuTemp {}
            }
        }

        Rectangle {
            radius: root.radius
            implicitHeight: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: clock.implicitWidth + root.spaceOffset

            RowLayout {
                id: clock
                spacing: root.interSpace
                anchors.centerIn: parent

                Caffeine {}
                Calendar {}
            }
        }
    }
    RowLayout {
        anchors.centerIn: parent
        anchors.top: parent.top
        spacing: root.space

        Rectangle {
            radius: root.radius
            height: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: middle.implicitWidth + root.spaceOffset

            RowLayout {
                id: middle
                spacing: root.interSpace
                anchors.centerIn: parent

                Workspaces {}
                WindowTitle {}
            }
        }
    }
    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: root.spaceOffset
        spacing: root.space

        Rectangle {
            radius: root.radius
            implicitHeight: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: brightSound.implicitWidth + root.spaceOffset

            RowLayout {
                id: brightSound
                spacing: root.interSpace
                anchors.centerIn: parent

                Brightness {}
                OutputSound {}
                InputSound {}
            }
        }

        Rectangle {
            radius: root.radius
            implicitHeight: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: sysTray.implicitWidth + root.spaceOffset

            RowLayout {
                id: sysTray
                spacing: root.interSpace
                anchors.centerIn: parent

                Network {}
                Bluetooth {}
                Battery {}
                PowerProfiles {}
            }
        }

        Rectangle {
            radius: root.radius
            implicitHeight: root.implicitHeight
            color: Global.backgroundColor
            implicitWidth: shutdown.implicitWidth + root.spaceOffset

            RowLayout {
                id: shutdown
                spacing: root.interSpace
                anchors.centerIn: parent

                Shutdown {}
            }
        }
    }
}
