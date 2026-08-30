import QtQuick
import Quickshell

Item {
    id: root

    required property var wallpaper

    signal selected()

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

        Image {
            anchors.verticalCenter: parent.verticalCenter

            width: 80
            height: 48

            source: root.wallpaper.path

            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            layer.enabled: true
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 3

            Text {
                text: root.wallpaper.name

                color: "white"

                font.pixelSize: 15
                font.weight: Font.Medium

                elide: Text.ElideRight
            }

            Text {
                text: root.wallpaper.path

                color: Qt.rgba(1, 1, 1, 0.55)

                font.pixelSize: 12

                elide: Text.ElideMiddle
            }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: {
            root.selected()
        }
    }
}
