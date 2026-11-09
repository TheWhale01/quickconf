import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Row {
    id: root
    spacing: 15

    readonly property int iconSize: 17

    Repeater {
        model: SystemTray.items

        delegate: Item {
            property point clickPos: Qt.point(0, 0)

            id: trayContainer
            width: 10
            height: 10

            IconImage {
                anchors.centerIn: parent
                source: modelData.icon
                mipmap: true
                width: root.iconSize
                height: root.iconSize
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
                    console.log(modelData.id)
                    if (mouse.button == Qt.LeftButton)
                        modelData.activate()
                    else if ((mouse.button == Qt.RightButton) && modelData.hasMenu)
                        trayMenu.open()
                }
            }
        }
    }
}
