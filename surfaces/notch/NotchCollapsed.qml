import QtQuick

import "../../components"

Item {
    id: root

    required property var screen

    property real paddingX: 20
    property real paddingY: 5

    implicitWidth: layout.implicitWidth + paddingX * 2
    implicitHeight: layout.implicitHeight + paddingY * 2

    anchors.fill: parent

    Row {
        id: layout

        anchors.centerIn: parent

        spacing: 16

        Clock {
            color: "white"
            font.family: "JetBrains Mono"
            font.pixelSize: 16
            font.weight: Font.Bold

            timeFormat: "h:mm:ss AP - dddd, MMMM d, yyyy"
        }
    }
}
