//Weatherbox.qml

import Quickshell
import QtQuick
import QtQml
import Quickshell.Io

Rectangle {
    id: mainRect
    anchors.fill: parent

    property real fadeOpacity: 0

    Behavior on fadeOpacity { NumberAnimation { duration: 200 } }

    radius: 20
    color: "#303030"
    opacity: fadeOpacity

    Text {
        text: "put some wether shit here fr"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        font.pixelSize: 20
        font.family: "Jetbrains Mono NL"
        color: "#00ffd2"
    }

}