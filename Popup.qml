//Popup.qml

import Quickshell
import QtQuick

PopupWindow {
    property int xPos: -1
    

    anchor.window: triggerWindow
    anchor.rect.x: xPos
    anchor.rect.y: -implicitHeight/2 + triggerWindow.height/2

    implicitWidth: 600
    implicitHeight: 400

    Behavior on xPos { NumberAnimation { duration: 200 } }

    color: "transparent"

    Defaultbox {
        id: defaultBox
    }

    visible: triggerWindow.expanded

    onVisibleChanged: {
        if (visible) {
            xPos = 50
            defaultBox.fadeOpacity = 0.9
        } else {
            xPos = -1
            defaultBox.fadeOpacity  = 0
        }
    }
} 