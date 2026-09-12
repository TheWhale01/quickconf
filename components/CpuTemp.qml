import QtQuick
import Quickshell.Io

import ".."

Text {
    property double cpuTemp: 0.0
    property color tempColor: Global.fontColor
    readonly property color darkRed: "#8b0000"
    readonly property color red: "#ad1f2f"
    readonly property color lightRed: "#d22f2f"
    readonly property color orangeRed: "#ff471a"
    readonly property color tomato: "#ff6347"
    readonly property color darkOrange: "#ff8c00"
    readonly property color orange: "#ffa500"
    readonly property color lightBlue: "#add8e6"
    readonly property color skyBlue: "#87ceeb"
    readonly property color steelBlue: "#4682b4"
    readonly property color royalBlue: "#4169e1"
    readonly property color blue: "#0000ff"
    readonly property color darkBlue: "#00008b"

    id: root

    function getColor() {
        if (root.cpuTemp >= 90)
            root.tempColor = root.darkRed
        else if (root.cpuTemp >= 85)
            root.tempColor = root.red
        else if (root.cpuTemp >= 80)
            root.tempColor = root.lightRed
        else if (root.cpuTemp >= 80)
            root.tempColor = root.lightRed
        else if (root.cpuTemp >= 75)
            root.tempColor = root.orangeRed
        else if (root.cpuTemp >= 70)
            root.tempColor = root.tomato
        else if (root.cpuTemp >= 65)
            root.tempColor = root.darkOrange
        else if (root.cpuTemp >= 60)
            root.tempColor = root.orange
        else if (root.cpuTemp >= 45)
            root.tempColor = Global.fontColor
        else if (root.cpuTemp >= 40)
            root.tempColor = root.lightBlue
        else if (root.cpuTemp >= 35)
            root.tempColor = root.skyBlue
        else if (root.cpuTemp >= 30)
            root.tempColor = root.steelBlue
        else if (root.cpuTemp >= 25)
            root.tempColor = root.royalBlue
        else if (root.cpuTemp >= 20)
            root.tempColor = root.blue
        else
            root.tempColor = root.darkBlue
    }

    Process {
        id: cpuTempProc
        command: ["sh", "-c", "sensors | grep 'Tctl' | awk '{print $2}' | tr -d '+°C'"]
        stdout: SplitParser {
            onRead: data => {
                root.cpuTemp = parseFloat(data)
                root.getColor()
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuTempProc.running = true
    }

    text: " " + root.cpuTemp + "°C"
    color: root.tempColor
    font: Global.font
}
