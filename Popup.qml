//Popup.qml

import Quickshell
import QtQuick

PopupWindow {
    id: root
    property int xPos: -1
    property int yPos: -implicitHeight/2 + triggerWindow.height/2

    property bool scrollable: true

    property bool pcStats: true
    property bool musicPlayer: false
    property bool weather: false
    

    anchor.window: triggerWindow
    anchor.rect.x: xPos
    anchor.rect.y: yPos

    implicitWidth: 600
    implicitHeight: 400

    Behavior on xPos { NumberAnimation { duration: 200 } }
    Behavior on yPos { NumberAnimation { duration: 200 } }

    color: "transparent"
    
    Defaultbox {
        id: defaultBox
        visible: pcStats
    }

    Weatherbox {
        id: weatherBox
        visible: weather
    }

    Animations {
        id: animManager
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

    

    Timer {
        id: scrollCooldown

        interval: 1000
        running: false
        onTriggered: scrollable = true
        
    }

    MouseArea {
        anchors.fill: parent

        onWheel: (wheel)=> {
            if (wheel.angleDelta.y > 0 && scrollable) {
                if (pcStats) {
                    animManager.upToWeatherAnim.running = true
                }
                scrollable = false
                scrollCooldown.running = true
            } else if (wheel.angleDelta.y < 0 && scrollable) {
                if (weather) {
                    animManager.downToStatsAnim.running = true
                }
                scrollable = false
                scrollCooldown.running = true
            }
        }
    }
} 