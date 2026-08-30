import QtQuick
import Quickshell

import "launcher"

Item {
    id: root

    property alias searchText: search.text

    LauncherModel {
        id: launcherModel

        searchText: root.searchText
    }

    Column {
        anchors {
            fill: parent
            margins: 16
        }

        spacing: 12

        TextInput {
            id: search

            width: parent.width
            height: 44

            color: "white"

            font.pixelSize: 16

            verticalAlignment: TextInput.AlignVCenter

            selectByMouse: true

            Text {
                anchors.fill: parent

                text: "Search..."
                color: Qt.rgba(1, 1, 1, 0.4)

                font: parent.font

                verticalAlignment: Text.AlignVCenter

                visible: !parent.text
            }
        }

        ListView {
            id: appList

            width: parent.width
            height: parent.height - search.height - spacing

            spacing: 6

            clip: true

            model: launcherModel.applications

            delegate: AppEntry {
                required property var modelData

                app: modelData
            }
        }
    }

    Component.onCompleted: {
        search.forceActiveFocus()
    }
}
