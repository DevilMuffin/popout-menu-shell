//Defaultbox.qml

import Quickshell
import QtQuick
import Quickshell.Io


Rectangle {
    id: mainRect
    anchors.fill: parent

    property real fadeOpacity: 0

    Behavior on fadeOpacity { NumberAnimation { duration: 200 } }

    radius: 5
    color: "#303030"
    opacity: fadeOpacity

    property string userName: ""
    property string hostName: ""
    property real memoryUsed: 0

    Column {
        id: stats
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter
        y: 100

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
                text: "meow"
                font.family: "JetBrains Mono NL"
                font.pixelSize: 20
                color: "#00ffd2"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
            text: "RAM: " + (mainRect.memoryUsed / 1000000000).toFixed(1) + " GB"
            font.pixelSize: 16
            font.family: "Jetbrains Mono NL"
            color: "#ff4499"
            }   
        }

        
    }

    Process {
        id: proc
        running: true
        command: ["fastfetch", "--config", "popout.jsonc", "--format", "json"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text);

                mainRect.userName = data.find(item => item.type === "Title").result.userName;
                mainRect.hostName = data.find(item => item.type === "Title").result.hostName;
                mainRect.memoryUsed = data.find(item => item.type === "Memory").result.used;
            }
            
        }
    }

}
