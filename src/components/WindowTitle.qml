import QtQuick
import Quickshell.Hyprland

import ".."

Text {
    property string rawTitle: Hyprland.activeToplevel?.title ?? ""

    id: root

    function getFormattedTitle() {
        var windowName = root.rawTitle
        if (windowName != "") {
            if (windowName.length > 52)
                windowName = windowName.substring(0, 49) + "..."
        }
        return "  " + windowName
    }

    text: root.getFormattedTitle()
    color: Global.fontColor
    font: Global.font
}
