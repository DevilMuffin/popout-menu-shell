// Menu.qml

import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    PanelWindow {
        id: triggerWindow

        property int height: 50

        anchors {
            left: true
        }

        color: "transparent"

        implicitWidth: 10
        implicitHeight: height

        property bool expanded: false

        Rectangle {
            anchors.fill: parent

            radius: 5
            color: "#303030"
        }

        MouseArea {
        id: trigger
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: triggerWindow.expanded = !triggerWindow.expanded
        }
        
        Popup {}     
    }
}