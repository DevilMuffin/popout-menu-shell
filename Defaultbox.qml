//Box.qml

import Quickshell
import QtQuick
import Quickshell.Io


Rectangle {
    id: mainRect
    anchors.fill: parent

    radius: 5
    color: "#303030"

    property string title: ""
    property real memoryUsed: 0

    Column {
        id: stats
        spacing: 10

        Text {
            text: "CPU: " + mainRect.cpuUsage + "%"
            color: "#00ffd2"
        }

        Text {
            text: "RAM: " + (mainRect.memoryUsed / 1000000000).toFixed(1) + " GB"
            font.pixelSize: 24
            color: "#ff4499"
        }
    }

    Process {
        id: proc
        running: true
        command: ["fastfetch", "--config", "popout.jsonc", "--format", "json"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text);

                //mainRect.title = data.find(item => item.type === "")
                mainRect.memoryUsed = data.find(item => item.type === "Memory").result.used;
            }
            
        }
    }

}
