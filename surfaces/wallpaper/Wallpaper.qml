pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../wallpaper"
import "../../services"

Item {
    id: root

    property string query: ""
    property int selectedIndex: 0

    signal closed()
    signal wallpaperSelected(string path)

    onWallpaperSelected: path => {
        WallpaperManager.setWallpaper(path)
        root.closed()
    }

    implicitWidth: 700
    implicitHeight: 500

    readonly property var wallpapers: WallpaperModel {
        id: wallpaperModel
    }

    readonly property var filteredWallpapers: {
        const query = root.query.trim().toLowerCase()

        if (!query)
            return wallpaperModel.wallpapers

        return wallpaperModel.wallpapers.filter(wallpaper =>
            wallpaper.name.toLowerCase().includes(query)
        )
    }

    Rectangle {
        anchors.fill: parent

        radius: 24
        color: "black"
    }

    Column {
        anchors {
            fill: parent
            margins: 20
        }

        spacing: 12

        Rectangle {
            width: parent.width
            height: 48

            radius: 14

            color: Qt.rgba(1, 1, 1, 0.08)

            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.10)

            TextInput {
                id: search

                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 16
                }

                focus: true

                color: "white"
                selectionColor: Qt.rgba(1, 1, 1, 0.2)

                font.family: "JetBrains Mono"
                font.pixelSize: 16

                verticalAlignment: TextInput.AlignVCenter

                onTextChanged: {
                    root.query = text
                    root.selectedIndex = 0
                }

                Keys.onEscapePressed: {
                    root.closed()
                }
            }

            Text {
                anchors {
                    left: parent.left
                    leftMargin: 16
                    verticalCenter: parent.verticalCenter
                }

                text: "Search wallpapers..."
                color: Qt.rgba(1, 1, 1, 0.35)

                font.family: "JetBrains Mono"
                font.pixelSize: 16

                visible: search.text.length === 0
            }
        }

        Rectangle {
            width: parent.width
            height: 1

            color: Qt.rgba(1, 1, 1, 0.15)
        }

        ListView {
            id: results

            width: parent.width
            height: parent.height - search.height - 13

            clip: true

            spacing: 6

            model: root.filteredWallpapers

            currentIndex: root.selectedIndex

            delegate: WallpaperItem {
                required property var modelData

                width: results.width
                height: 64

                wallpaper: modelData

                onSelected: {
                    WallpaperManager.setWallpaper(modelData.path)
                    root.closed()
                }
            }
        }
    }

    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
            if (root.selectedIndex > 0)
                root.selectedIndex--

            event.accepted = true
            break

        case Qt.Key_Down:
            if (root.selectedIndex < results.count - 1)
                root.selectedIndex++

            event.accepted = true
            break

        case Qt.Key_Return:
        case Qt.Key_Enter:
	        if (results.currentItem)
	            results.currentItem.triggered(
	                results.currentItem.wallpaper.path
	            )

            event.accepted = true
            break

        case Qt.Key_Escape:
            root.closed()
            event.accepted = true
            break
        }
    }

    Component.onCompleted: {
        search.forceActiveFocus()
    }
}
