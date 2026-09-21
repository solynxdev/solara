import QtQuick

import "../../theme"
import "../../components"

Item {
    id: root

    required property var command

    signal triggered()

    Rectangle {
        anchors.fill: parent

        radius: 14

        color: mouse.containsMouse
            ? Theme.surfaceContainerHigh
            : "transparent"

        Behavior on color {
            CAnim {}
        }
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter

            leftMargin: 14
            rightMargin: 14
        }

        spacing: 3

        Text {
            text: root.command.name

            color: Theme.text

            font.pixelSize: 15
            font.weight: Font.Medium
        }

        Text {
            text: root.command.description || ""

            width: parent.width

            color: Theme.textSecondary

            font.pixelSize: 12

            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent

        hoverEnabled: true

        onClicked: root.triggered()
    }
}
