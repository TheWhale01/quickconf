import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import ".."

RowLayout {
    property var activeWorkspaces: Hyprland.workspaces.values.filter(w => w.id > 0).sort((a, b) => a.id - b.id)

    id: rootLayout
    spacing: 3

    Repeater {
        model: parent.activeWorkspaces

        Rectangle {
            required property int index
            required property var modelData
            readonly property bool hovered: mouseArea.containsMouse
            property bool active: Hyprland.focusedWorkspace?.id == modelData.id

            id: workspaceBtn
            radius: 13
            Layout.preferredHeight: label.implicitHeight + 6
            Layout.preferredWidth: label.implicitWidth + (active ? 35 : 12)
            color: hovered ? Global.hoverColor : (active ? Global.fontColor : "transparent")

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: [0.55, -0.68, 0.48, 1.682]
                }
            }
            Behavior on color {
                ColorAnimation { duration: 300 }
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = "${parent.modelData.id}" })`)
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: workspaceBtn.modelData.id
                color: (workspaceBtn.active || workspaceBtn.hovered) ? Global.backgroundColor : Global.fontColor
                font: Global.font

                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }
        }
    }
}
