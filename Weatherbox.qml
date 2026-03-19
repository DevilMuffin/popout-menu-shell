//Weatherbox.qml

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell.Io

Rectangle {
    id: mainRect
    anchors.fill: parent

    Icons {
        id: icons
    }

    property real fadeOpacity: 0

    Behavior on fadeOpacity { NumberAnimation { duration: 200 } }

    radius: 20
    color: "#303030"
    opacity: fadeOpacity

    property real lat: 0
    property real lon: 0

    property real temp: 0
    property string tempUnit: ""

    property var forecastArray: []

    property var daysInMonthArray: []

    property var daysOfTheWeek: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]

    property int todayDay: new Date().getDate()



    // Functions
    function weatherIcon(code) {
        switch(code) {
            case 0: return icons.sunny
            case 1: return icons.partlyCloudy
            case 2: return icons.cloudy
            case 3: return icons.overcast
            case 45: case 48: return icons.fog
            case 51: case 53: case 55: return icons.drizzle
            case 61: case 63: case 65: case 80: case 81: case 82:return icons.rain
            case 71: case 73: case 75: return icons.snow
            case 95: case 99: return icons.thunderstorms
            default: return "Unknown"
        }
    }

    function getWeekdayFromDate(dateString) {
        var date = new Date(dateString)
        var today = new Date()

        if (date.getDate() === today.getDate() &&
            date.getMonth() === today.getMonth() &&
            date.getFullYear() === today.getFullYear()) {
            return "Today"
        }

        var days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        return days[date.getDay()]
    }

    function getDaysInMonth() {
        const today = new Date()
        const year = today.getFullYear()
        const month = today.getMonth()
        const daysInMonth = new Date(year, month + 1, 0).getDate()
        const firstDay = new Date(year, month, 1).getDay()
        
        const offset = (firstDay + 6) % 7
        const daysArray = []

        for (let i = 0; i < offset; i++) {
            daysArray.push("")
        }

        for (let d = 1; d <= daysInMonth; d++) {
            daysArray.push(d)
        }

        mainRect.daysInMonthArray = daysArray
    }

    Component.onCompleted: {
        getDaysInMonth()
    }

    // Row for current temp and calander
    Row {
        spacing: 40

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.topMargin: 30
        anchors.leftMargin:20
        anchors.rightMargin: 20

        // Current temp rectangle
        Rectangle {
            radius: 20
            color: "#141414"

            implicitHeight: 200
            implicitWidth: mainRect.width / 2 - 80
            
            Text {
                text: "Right Now"

                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                font.pixelSize: 20
                font.family: "Jetbrains Mono NL"
                color: "white"
            }

            Image {
                source: forecastArray.length > 0 ? forecastArray[0].weatherIcon : ""

                width: 100
                height: 100

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: temp + tempUnit

                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                font.pixelSize: 20
                font.family: "Jetbrains Mono NL"
                color: "white"
            }
        }

        Rectangle {
            radius: 20
            color: "#141414"

            implicitHeight: 200
            implicitWidth: mainRect.width / 2 

            GridLayout {
                columns: 7
                columnSpacing: 10
                rowSpacing: 5
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: daysOfTheWeek

                    Text {
                        anchors.fill: parent.fill
                        text: modelData
                        color: "white"
                        font.family: "Jetbrains Mono NL"
                        font.pixelSize: 15

                    }
                }

                Repeater {
                    model: daysInMonthArray

                    Rectangle {
                        radius: 5

                        implicitWidth: 22
                        implicitHeight: 22

                        color: modelData === todayDay ? "#00ffd2" : "transparent"

                        Text {
                            anchors.fill: parent.fill
                            text: modelData
                            color: modelData === todayDay ? "black" : "white"
                            font.family: "Jetbrains Mono NL"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

            }
        }
    }


    // Rectangle for weekly forecast
    Rectangle {
        radius: 20
        color: "#141414"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20

        implicitHeight: 120
        implicitWidth: mainRect.width - 40

        Row {
            anchors.fill: parent.fill
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 7.5
            anchors.bottomMargin: 20

            Repeater {
                model: mainRect.forecastArray

                Rectangle {
                    radius: 20
                    color: "#545454"

                    implicitHeight: 100
                    implicitWidth: 70

                    Text {
                        text: modelData.day

                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter

                        font.pixelSize: 12
                        font.family: "Jetbrains Mono NL"
                        color: "white"
                    }


                    Image {
                        source: modelData.weatherIcon

                        width: 36
                        height: 36

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenterOffset: -13

                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: modelData.maxTemp + mainRect.tempUnit

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 13
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter

                        font.pixelSize: 12
                        font.family: "Jetbrains Mono NL"
                        color: "white"
                    }

                    Text {
                        text: modelData.minTemp + mainRect.tempUnit

                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter

                        font.pixelSize: 12
                        font.family: "Jetbrains Mono NL"
                        color: "#b6b6b6"
                    }
                }
            }
        }
    }

    // Processes
    Process {
        id: locaitonGrabber
        running: true
        command: ["curl", "-s", "http://ip-api.com/json/"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text)
                lat = data.lat
                lon = data.lon

                currentTempGrabber.running = true
                weatherForecastGrabber.running = true
            }
        }
    }

    Timer {
        id: tempTimer
        interval: 600000
        running: true
        repeat: true
        onTriggered: currentTempGrabber.running = true
    }


    Process {
        id: currentTempGrabber
        running: false
        command: ["curl", "-s", "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current_weather=true"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text)
                temp = data.current_weather.temperature
                tempUnit = data.current_weather_units.temperature
            }
        }    
    }

    Process {
        id: weatherForecastGrabber
        running: false
        command: ["curl", "-s", "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"]
        stdout: StdioCollector {
            onStreamFinished: {
                var data = JSON.parse(text)

                var newArray = []

                var daysCount = data.daily.time.length
                for (var i = 0; i < daysCount; i++) {
                    newArray.push({
                        day: getWeekdayFromDate(data.daily.time[i]),
                        minTemp: data.daily.temperature_2m_min[i],
                        maxTemp: data.daily.temperature_2m_max[i],
                        weatherIcon: weatherIcon(data.daily.weathercode[i])
                    })
                }

                mainRect.forecastArray = newArray
            }
        }
    }
}