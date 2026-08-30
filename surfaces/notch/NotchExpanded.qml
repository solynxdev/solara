import "../../services"
import "../../theme"
import QtQuick
import Quickshell

Item {
    id: root

    implicitWidth: 300
    implicitHeight: 300

    Column {
        anchors.centerIn: parent
        spacing: 8

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clockTime.date, "hh:mm")
            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: 44
                weight: Font.Medium
            }

        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Click the notch to search"
            color: Theme.textSecondary

            font {
                family: Theme.fontFamily
                pixelSize: 12
            }

        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Repeater {
                model: [{
                    "label": ThemeManager.currentName,
                    "accent": false
                }, {
                    "label": ">settings",
                    "accent": true
                }, {
                    "label": ">calc",
                    "accent": false
                }]

                delegate: Item {
                    required property var modelData

                    width: pillText.implicitWidth + 20
                    height: 24

                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: modelData.accent ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.16) : Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, 0.08)
                        border.width: modelData.accent ? 1 : 0
                        border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.4)
                    }

                    Text {
                        id: pillText

                        anchors.centerIn: parent
                        text: modelData.label
                        color: modelData.accent ? Theme.accent : Theme.textSecondary

                        font {
                            family: Theme.fontFamily
                            pixelSize: 10
                        }

                    }

                }

            }

        }

    }

    SystemClock {
        id: clockTime

        precision: SystemClock.Minutes
    }

}
