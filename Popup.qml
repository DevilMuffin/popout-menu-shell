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

    property bool scrollable: true

    Timer {
        id: scrollCooldown

        interval: 1000
        running: false
        onTriggered: triggerWindow.scrollable = true
        
    }

    MouseArea {
        anchors.fill: parent

        onWheel: (wheel)=> {
            if (wheel.angleDelta.y > 0 && scrollable) {
                console.log("Scrolled up")
                scrollable = false
                scrollCooldown.running = true
            } else if (wheel.angleDelta.y < 0 && scrollable) {
                scrollable = false
                scrollCooldown.running = true
                console.log("Scrolled down")
            }
        }
    }
} 