import QtQuick
import Quickshell

Item {
    id: root

    required property var scheme

    signal selected(string id)

    function select() {
        root.selected(root.scheme.id)
    }

    Rectangle {
        anchors.fill: parent

        radius: 14

        color: mouse.containsMouse
            ? Qt.rgba(1, 1, 1, 0.10)
            : Qt.rgba(1, 1, 1, 0.05)

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    Row {
        anchors {
            fill: parent
            leftMargin: 14
            rightMargin: 14
        }

        spacing: 14

        Row {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 3

            Repeater {
                model: [
                    root.scheme.colors.background,
                    root.scheme.colors.surface,
                    root.scheme.colors.accent,
                    root.scheme.colors.text
                ]

                delegate: Rectangle {
                    required property string modelData

                    width: 14
                    height: 40

                    radius: 5

                    color: modelData
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 3

            Text {
                text: root.scheme.name

                color: "white"

                font.pixelSize: 15
                font.weight: Font.Medium
            }

            Text {
                text: root.scheme.description

                color: Qt.rgba(1, 1, 1, 0.55)

                font.pixelSize: 12

                elide: Text.ElideRight
            }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: {
            root.select()
        }
    }
}
