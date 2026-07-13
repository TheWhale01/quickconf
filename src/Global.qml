pragma Singleton
import QtQuick

QtObject {
    readonly property color globalTextColor: "#cdd6f4"
    readonly property color backgroundColor: "#11111b"
    readonly property color hoverColor: "#f5c2e7"
    readonly property font globalFont: Qt.font({
        family: "CaskaydiaCove NF",
        pixelSize: 13,
        weight: Font.Bold,
    })

    id: global
}
