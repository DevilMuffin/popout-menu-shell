// Musicbox.qml

import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris

Rectangle {
    id: mainRect
    anchors.fill: parent

    property real fadeOpacity: 0
    Behavior on fadeOpacity { NumberAnimation { duration: 200 } }

    radius: 20
    color: "#303030"
    opacity: fadeOpacity

    readonly property var list: Mpris.players.values
    property var active: null

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            updateActivePlayer()
        }
    }

    function updateActivePlayer() {
        var currentlyPlaying = null;
        for (var i = 0; i < list.length; i++) {
            if (list[i]?.isPlaying) {
                currentlyPlaying = list[i];
                break;
            }
        }

        if (currentlyPlaying) {
            if (active !== currentlyPlaying) active = currentlyPlaying;
        } else {
            if (!active && list.length > 0) active = list[0];
        }
    }

    Timer {
        interval: 500
        running: root.visible && list.length > 0
        repeat: true
        triggeredOnStart: true
        onTriggered: updateActivePlayer()
    }

    Component.onCompleted: updateActivePlayer()

    FrameAnimation {
        running: active?.isPlaying ?? false
        onTriggered: {
            if (active) active.positionChanged()
        }
    }

    Rectangle {
        id: artDisplay
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30

        radius: 5
        color: "white"
        border.width: 10
        border.color: "black"

        width: art.width + 10
        height: 170

        Image {
            id: art
            anchors.centerIn: parent
            source: active?.trackArtUrl ?? ""
            height: 160
            fillMode: Image.PreserveAspectFit
            cache: false
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset:20

        color: "black"
        radius: 5
        height: 30
        width: textItem.paintedWidth + 20

        Text {
            id: textItem
            anchors.centerIn: parent
            text: active?.trackTitle ?? "No track"
            color: "white"
            font.pixelSize: 16
        }
    }

    Slider {
        id: positionSlider

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120

        width: 300
        height: 30

        from: 0
        to: (active?.length ?? 1) / 1000

        property bool userDragging: false

        value: 0

        onPressedChanged: {
            userDragging = pressed
            if (!pressed && active) {
                active.position = value * 1000
            }
        }

        Timer {
            interval: 100
            repeat: true
            running: active?.isPlaying && !positionSlider.userDragging
            onTriggered: {
                if (active) positionSlider.value = active.position / 1000
            }
        }

        background: Rectangle {
            anchors.fill: parent
            radius: 5
            color: "black"

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 20
                height: 6
                radius: 3
                color: "white"

                Rectangle {
                    width: parent.width * positionSlider.visualPosition
                    height: parent.height
                    radius: 3
                    color: "#00ffd2"
                }
            }
        }

        handle: Rectangle {
            width: 14
            height: 14
            radius: width / 2
            color: "white"

            x: 10 + positionSlider.visualPosition * (positionSlider.availableWidth - 20)
            y: (positionSlider.height - height) / 2

            scale: positionSlider.pressed ? 1.2 : 1
            Behavior on scale { NumberAnimation { duration: 100 } }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        z: 10

        radius: 5
        color: "black"
        height: 75
        width: 240

        Row {
            spacing: 20
            anchors.centerIn: parent

            Rectangle {
                id: playPrevious
                height: 50
                width: 50
                radius: width/2
                color: "black"
                Behavior on color { ColorAnimation { duration: 200 } }

                Text {
                    id: previousLabel
                    anchors.centerIn: parent
                    text: "⏮"
                    font.pixelSize: 30
                    font.family: "Jetbrains Mono NL"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true 
                    onEntered: { parent.color = "#00ffd2"; previousLabel.color = "black" }
                    onExited: { parent.color = "black"; previousLabel.color = "white" }
                    onClicked: active.previous()
                }
            }

            Rectangle {
                id: playAndPause
                height: 50
                width: 50
                radius: width/2
                color: "black"
                Behavior on color { ColorAnimation { duration: 200 } }

                Text {
                    id: playPauseLabel
                    anchors.centerIn: parent
                    text: active?.isPlaying ? "⏸" : "▶"
                    font.pixelSize: 30
                    font.family: "Jetbrains Mono NL"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true 
                    onEntered: { parent.color = "#00ffd2"; playPauseLabel.color = "black" }
                    onExited: { parent.color = "black"; playPauseLabel.color = "white" }
                    onClicked: active.togglePlaying()
                }   
            }

            Rectangle {
                id: playNext
                height: 50
                width: 50
                radius: width/2
                color: "black"
                Behavior on color { ColorAnimation { duration: 200 } }

                Text {
                    id: nextLabel
                    anchors.centerIn: parent
                    text: "⏭"
                    font.pixelSize: 30
                    font.family: "Jetbrains Mono NL"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true 
                    onEntered: { parent.color = "#00ffd2"; nextLabel.color = "black" }
                    onExited: { parent.color = "black"; nextLabel.color = "white" }
                    onClicked: active.next()
                }
            }
        }
    }
}