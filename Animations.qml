//Animations.qml

import Quickshell
import QtQuick


Scope {
    id: animManager

    property alias upToWeatherAnim: upToWeather
    property alias downToStatsAnim: downToStats
    
    SequentialAnimation {
        id: upToWeather
        running: false

        ParallelAnimation {
            NumberAnimation { target: root; property: "yPos"; to: -screen.height; duration: 250}
            NumberAnimation { target: defaultBox; property: "fadeOpacity"; to: 0; duration: 250}
        }

        ScriptAction {
            script: {
                pcStats = false
            }
        }

        NumberAnimation { target: root; property: "yPos"; to: screen.height; duration: 250}

        ScriptAction {
            script: {
                weather = true
            }
        }

        ParallelAnimation {
            NumberAnimation { target: root; property: "yPos"; to: -implicitHeight/2 + triggerWindow.height/2; duration: 250}
            NumberAnimation { target: weatherBox; property: "fadeOpacity"; to: 0.9; duration: 250}
        }

    }

    SequentialAnimation {
        id: downToStats
        running: false

        ParallelAnimation {
            NumberAnimation { target: root; property: "yPos"; to: screen.height; duration: 250}
            NumberAnimation { target: weatherBox; property: "fadeOpacity"; to: 0; duration: 250}
        }

        ScriptAction {
            script: {
                weather = false
            }
        }

        NumberAnimation { target: root; property: "yPos"; to: -screen.height; duration: 250}

        ScriptAction {
            script: {
                pcStats = true
            }
        }

        ParallelAnimation {
            NumberAnimation { target: root; property: "yPos"; to: -implicitHeight/2 + triggerWindow.height/2; duration: 250}
            NumberAnimation { target: defaultBox; property: "fadeOpacity"; to: 0.9; duration: 250}
        }
    }
}