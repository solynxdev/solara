import QtQuick
import Quickshell

Item {
    id: root

    required property var workspace
    required property int workspaceIndex

    readonly property bool active: root.workspace.active

    implicitWidth: content.implicitWidth
    implicitHeight: 22

    Rectangle {
        anchors.fill: parent

        radius: height / 2

        color: root.active
            ? Qt.rgba(1, 1, 1, 0.20)
            : Qt.rgba(1, 1, 1, 0.15)
    }

    Row {
        id: content

        anchors.centerIn: parent

        spacing: 4

        Rectangle {
            width: 20
            height: 20

            radius: width / 2

            color: root.active
                ? "white"
                : Qt.rgba(1, 1, 1, 0.25)

            Text {
                anchors.centerIn: parent

                text: root.workspaceIndex

                color: root.active
                    ? "black"
                    : Qt.rgba(1, 1, 1, 0.75)

                font.pixelSize: 11
                font.weight: Font.Bold
            }
        }

        Repeater {
            model: root.workspace.toplevels

            delegate: WorkspaceApp {
                required property var modelData
                size: 20

                toplevel: modelData
            }
        }
    }
}
