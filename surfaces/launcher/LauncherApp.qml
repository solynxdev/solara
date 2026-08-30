import QtQuick
import Quickshell

Item {
    id: root

    required property var app

    signal launched()

    function activate() {
        root.app.execute()
        root.launched()
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

        Image {
            anchors.verticalCenter: parent.verticalCenter

            width: 40
            height: 40

            source: root.app.icon
                ? Quickshell.iconPath(root.app.icon, true)
                : ""

            fillMode: Image.PreserveAspectFit
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            spacing: 3

            Text {
                text: root.app.name

                color: "white"

                font.pixelSize: 15
                font.weight: Font.Medium
            }

            Text {
                text: root.app.genericName || root.app.comment

                width: parent.width

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

        onClicked: root.activate()
    }
}
