//Weatherbox.qml

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

    property real lat: 0
    property real lon: 0

    property real temp: 0
    property string tempUnit: ""

    property var forecastArray: []

    function weatherText(code) {
        switch(code) {
            case 0: return "Sunny"
            case 1: return "Mostly clear"
            case 2: return "Partly cloudy"
            case 3: return "Overcast"
            case 45: case 48: return "Foggy"
            case 51: case 53: case 55: return "Drizzle"
            case 61: case 63: case 65: return "Rainy"
            case 71: case 73: case 75: return "Snowy"
            case 80: case 81: case 82: return "Rain showers"
            case 95: case 99: return "Thunderstorm"
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


    Text {
        text: "Temperature: " + temp + tempUnit

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        font.pixelSize: 20
        font.family: "Jetbrains Mono NL"
        color: "#00ffd2"
    }

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

                mainRect.forecastArray = []

                var daysCount = data.daily.time.length
                for (var i=0; i<daysCount; i++) {
                    mainRect.forecastArray.push({
                        day: getWeekdayFromDate(data.daily.time[i]),
                        minTemp: data.daily.temperature_2m_min[i],
                        maxTemp: data.daily.temperature_2m_max[i],
                        weather: weatherText(data.daily.weathercode[i])
                    })
                }

                console.log(JSON.stringify(mainRect.forecastArray, null, 2))
            }
        }
    }
}