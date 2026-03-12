//Defaultbox.qml

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

    property string userName: ""
    property string hostName: ""

    property string os: ""
    
    property real uptime: 0
    property int hours: 0
    property real minutes: 0

    property real memoryUsed: 0

    property string shell: ""

    property string windowManager: ""

    Column {
        id: stats
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter
        y: 75

        Text {
            text: mainRect.userName + "@" + mainRect.hostName
            font.pixelSize: 20
            font.family: "Jetbrains Mono NL"
            color: "#00ffd2"
        }

        Text {
            text: "─".repeat((mainRect.userName + "@" + mainRect.hostName).length)
            font.pixelSize: 20
            font.family: "Jetbrains Mono NL"
            color: "#00ffd2"
        }

        Column {
            spacing: 10

            Text {
                text: "OS: " + mainRect.os
                font.family: "JetBrains Mono NL"
                font.pixelSize: 20
                color: "#ff4499"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "Uptime: " + mainRect.hours + " " + "Hours " + mainRect.minutes + " " + "Minutes"
                font.family: "JetBrains Mono NL"
                font.pixelSize: 20
                color: "#00ffd2"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "RAM: " + (mainRect.memoryUsed / 1000000000).toFixed(2) + " GB"
                font.pixelSize: 20
                font.family: "Jetbrains Mono NL"
                color: "#af74f4"
            }   

            Text {
                text: "Shell: " + mainRect.shell
                font.pixelSize: 20
                font.family: "Jetbrains Mono NL"
                color: "#ffd00d"
            } 

            Text {
                text: "WM: " + mainRect.windowManager
                font.pixelSize: 20
                font.family: "Jetbrains Mono NL"
                color: "#b2ffa3"
            } 
        }

        
    }

    Process {
        id: proc
        running: false
        command: ["fastfetch", "--format", "json"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text);

                mainRect.userName = data.find(item => item.type === "Title").result.userName;
                mainRect.hostName = data.find(item => item.type === "Title").result.hostName;

                mainRect.os = data.find(item => item.type === "OS").result.prettyName;

                mainRect.uptime = data.find(item => item.type === "Uptime").result.uptime;
                mainRect.hours = Math.floor(((mainRect.uptime/1000)/60)/60)
                mainRect.minutes = Math.floor(((((mainRect.uptime/1000)/60)/60) - mainRect.hours) * 60)

                mainRect.memoryUsed = data.find(item => item.type === "Memory").result.used;

                mainRect.windowManager = data.find(item => item.type === "WM").result.prettyName;
            }
            
        }

    }

    Process {
    id: shellProc
    running: true
    command: ["sh", "-c", "basename $SHELL"]

    stdout: StdioCollector {
        onStreamFinished: {
            mainRect.shell = text.trim()
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: proc.running = true

    }

}
