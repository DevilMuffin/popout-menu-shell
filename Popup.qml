//Popup.qml

import Quickshell
import QtQuick

PopupWindow {
            property int xPos: -1

            anchor.window: triggerWindow
            anchor.rect.x: xPos
            anchor.rect.y: -implicitHeight/2 + triggerWindow.height/2

            implicitWidth: 400
            implicitHeight: 500

            Behavior on xPos { NumberAnimation { duration: 200 } }

            //Behavior on implicitWidth { NumberAnimation { duration: 200 } }
            //Behavior on implicitHeight { NumberAnimation { duration: 200 } }

            color: "transparent"

            Defaultbox {}

            visible: triggerWindow.expanded

            onVisibleChanged: {
                if (visible) {
                    //implicitWidth = 400
                    //implicitHeight = 500
                    xPos = 50
                } else {
                    //implicitWidth = 1
                    //mplicitHeight = 1
                    xPos = -1
                }
            }
        } 