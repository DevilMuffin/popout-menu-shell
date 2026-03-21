// Animations.qml

import Quickshell
import QtQuick

Scope {
    id: animManager

    property alias upToWeatherAnim: upToWeather
    property alias downToStatsAnim: downToStats

    SequentialAnimation {
        id: upToWeather

        ParallelAnimation {
            NumberAnimation {
                target: defaultBox
                property: "fadeOpacity"
                to: 0
                duration: 250
            }

            NumberAnimation {
                target: root
                property: "yPos"
                to: -screen.height
                duration: 300
                easing.type: Easing.InCubic
            }
        }

        NumberAnimation {
            target: root
            property: "yPos"
            to: screen.height
            duration: 1
        }

        ScriptAction { script: pcStats = false }
        PauseAnimation{ duration: 400 }
        ScriptAction { script: weather = true }

        ParallelAnimation {


            NumberAnimation {
                target: weatherBox
                property: "fadeOpacity"
                to: 0.9
                duration: 250
            }

            NumberAnimation {
                target: root
                property: "yPos"
                to: -root.implicitHeight/2 + triggerWindow.height/2
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    SequentialAnimation {
        id: downToStats

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "yPos"
                to: screen.height
                duration: 300
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: weatherBox
                property: "fadeOpacity"
                to: 0
                duration: 250
            }
        }

        NumberAnimation {
            target: root
            property: "yPos"
            to: -screen.height
            duration: 1
        }


        ScriptAction { script: weather = false }
        PauseAnimation{ duration: 400 }
        ScriptAction { script: pcStats = true }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "yPos"
                to: -root.implicitHeight/2 + triggerWindow.height/2
                duration: 300
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: defaultBox
                property: "fadeOpacity"
                to: 300
                duration: 250
            }
        }
    }
}