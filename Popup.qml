// Popup.qml

import Quickshell
import QtQuick

PopupWindow {
    id: root

    property int xPos: -20
    property int yPos: -implicitHeight/2 + triggerWindow.height/2

    property bool scrollable: true

    property bool pcStats: true
    property bool weather: false

    // Animation props
    property real popupOpacity: 0

    // visibility control
    property bool actuallyVisible: false
    

    anchor.window: triggerWindow
    anchor.rect.x: xPos
    anchor.rect.y: yPos

    implicitWidth: 600
    implicitHeight: 400

    visible: actuallyVisible

    color: "transparent"

    // Smooth position animation
    Behavior on xPos {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on yPos {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
        }
    }

    // 👇 MAIN CONTAINER (this is what we animate instead of PopupWindow)
    Item {
        id: content
        anchors.fill: parent

        opacity: popupOpacity
        scale: popupOpacity < 1 ? 0.97 : 1   // subtle pop effect

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutBack
                easing.overshoot: 1.15
            }
        }

        Defaultbox {
            id: defaultBox
            visible: pcStats
        }

        Weatherbox {
            id: weatherBox
            visible: weather
        }
    }

    Animations {
        id: animManager
    }

    // OPEN / CLOSE
    Connections {
        target: triggerWindow

        function onExpandedChanged() {
            if (triggerWindow.expanded) {
                actuallyVisible = true

                xPos = 50
                yPos = -implicitHeight/2 + triggerWindow.height/2

                popupOpacity = 1
                defaultBox.fadeOpacity = 0.9
            } else {
                popupOpacity = 0
                xPos = -20

                defaultBox.fadeOpacity = 0

                closeTimer.start()
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: actuallyVisible = false
    }

    // Scroll cooldown
    Timer {
        id: scrollCooldown
        interval: 300
        onTriggered: scrollable = true
    }

    MouseArea {
        anchors.fill: parent

        onWheel: (wheel)=> {
            if (wheel.angleDelta.y > 0 && scrollable) {
                if (pcStats) {
                    animManager.upToWeatherAnim.start()
                }
                scrollable = false
                scrollCooldown.start()
            } else if (wheel.angleDelta.y < 0 && scrollable) {
                if (weather) {
                    animManager.downToStatsAnim.start()
                }
                scrollable = false
                scrollCooldown.start()
            }
        }
    }
}