import QtQuick
import Quickshell

import "../../theme"

Item {
    id: root

    signal closed()

    implicitWidth: 700
    implicitHeight: 500

    Rectangle {
        anchors.fill: parent

        radius: 24
        color: Theme.surface
    }

    Column {
        anchors {
            fill: parent
            margins: 20
        }

        spacing: 12

        Text {
            text: "Settings"

            color: Theme.text
            font.pixelSize: 22
            font.weight: Font.Bold
        }

        Text {
            text: "The full settings UI ships in a later phase. "
                + "For now, tweak colors and values in config.json."

            color: Theme.textSecondary
            font.pixelSize: 13

            width: parent.width
            wrapMode: Text.WordWrap
        }

        Rectangle {
            width: parent.width
            height: 1

            color: Theme.border
        }

        Repeater {
            model: [
                "Appearance",
                "Wallpaper",
                "Bar",
                "Workspaces",
                "Power & Idle",
                "Integrations"
            ]

            delegate: Rectangle {
                required property string modelData

                width: parent.width
                height: 56

                radius: 14

                color: Qt.rgba(
                    Theme.text.r,
                    Theme.text.g,
                    Theme.text.b,
                    0.06
                )

                Text {
                    anchors.verticalCenter: parent.verticalCenter

                    x: 16

                    text: modelData
                    color: Theme.text
                    font.pixelSize: 15
                }

                Text {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    rightPadding: 16

                    text: "Soon"
                    color: Theme.textSecondary
                    font.pixelSize: 12
                }
            }
        }
    }

    Keys.onEscapePressed: root.closed()

    Component.onCompleted: forceActiveFocus()
}