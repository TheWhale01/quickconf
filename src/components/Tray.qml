import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: root
    spacing: 15
    readonly property var smallerIcons: ["blueman", "Network"]

    Repeater {
        model: SystemTray.items

        delegate: Item {
            property point clickPos: Qt.point(0, 0)

            id: trayContainer
            width: 10
            height: 25

            Image {
                anchors.centerIn: parent
                source: modelData.icon
                sourceSize.width: smallerIcons.includes(modelData.title) ? 9 : 18
                sourceSize.height: smallerIcons.includes(modelData.title) ? 9 : 18
            }

            QsMenuAnchor {
                id: trayMenu
                menu: modelData.menu
                anchor.item: trayContainer
                anchor.edges: Edges.Top
                anchor.margins.top: 20
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button == Qt.LeftButton)
                        modelData.activate()
                    else if ((mouse.button == Qt.RightButton) && modelData.hasMenu)
                        trayMenu.open()
                }
            }
        }
    }
}
