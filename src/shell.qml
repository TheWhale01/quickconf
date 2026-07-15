//@ pragma UseQApplication
import QtQuick
import Quickshell
import QtQuick.Layouts

import "./components"

PanelWindow {
    property int space: 20
    property int radius: 21
    property int spaceOffset: 30
    property int interSpace: 10

    id: barWindow
    anchors.top: true
    anchors.left: true
    anchors.right: true
    margins.top: 8
    implicitHeight: 30
    color: "transparent"

    RowLayout {
        anchors.leftMargin: barWindow.spaceOffset
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: barWindow.space

        Rectangle {
            radius: barWindow.radius
            implicitHeight: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: sysStats.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: sysStats
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                CpuUsage {}
                RamUsage {}
                CpuTemp {}
            }
        }

        Rectangle {
            radius: barWindow.radius
            implicitHeight: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: clock.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: clock
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                Caffeine {}
                Calendar {}
            }
        }
    }
    RowLayout {
        anchors.centerIn: parent
        anchors.top: parent.top
        spacing: barWindow.space

        Rectangle {
            radius: barWindow.radius
            height: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: middle.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: middle
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                Workspaces {}
                WindowTitle {}
            }
        }
    }
    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: barWindow.spaceOffset
        spacing: barWindow.space

        Rectangle {
            radius: barWindow.radius
            implicitHeight: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: brightSound.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: brightSound
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                Brightness {}
                OutputSound {}
                InputSound {}
            }
        }

        Rectangle {
            radius: barWindow.radius
            implicitHeight: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: sysTray.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: sysTray
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                Network {}
                Bluetooth {}
                Tray {}
                Battery {}
                PowerProfiles {}
            }
        }

        Rectangle {
            radius: barWindow.radius
            implicitHeight: barWindow.implicitHeight
            color: Global.backgroundColor
            implicitWidth: shutdown.implicitWidth + barWindow.spaceOffset

            RowLayout {
                id: shutdown
                spacing: barWindow.interSpace
                anchors.centerIn: parent

                Shutdown {}
            }
        }
    }
}
