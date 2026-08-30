pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../launcher"

Item {
    id: root

    property string query: ""
    property int selectedIndex: 0

    signal closed()
    signal commandRequested(string command)

    implicitWidth: 700
    implicitHeight: 500

    focus: true

    readonly property bool commandMode:
        root.query.startsWith(">")

    readonly property string searchQuery:
        root.commandMode
            ? root.query.slice(1).trim()
            : root.query.trim()

    readonly property var applications: ScriptModel {
        values: {
            const query = root.searchQuery.toLowerCase()

            return DesktopEntries.applications.values
                .filter(app => {
                    if (!query)
                        return true

                    return app.name.toLowerCase().includes(query)
                        || app.genericName.toLowerCase().includes(query)
                        || app.comment.toLowerCase().includes(query)
                        || app.keywords.some(
                            keyword => keyword.toLowerCase().includes(query)
                        )
                })
                .sort((a, b) =>
                    a.name.localeCompare(b.name)
                )
        }
    }

    readonly property var commands: [
        {
            id: "wallpaper",
            name: ">wallpaper",
            description: "Change your wallpaper"
        },
        {
            id: "scheme",
            name: ">scheme",
            description: "Change the current color scheme"
        },
        {
            id: "settings",
            name: ">settings",
            description: "Open Solara settings"
        },
        {
            id: "wifi",
            name: ">wifi",
            description: "Manage Wi-Fi connections"
        }
    ]

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
            id: searchBox

            width: parent.width
            height: 48

            radius: 14

            color: Qt.rgba(1, 1, 1, 0.08)

            border {
                width: 1
                color: Qt.rgba(1, 1, 1, 0.12)
            }

            Text {
                anchors {
                    left: parent.left
                    leftMargin: 14
                    verticalCenter: parent.verticalCenter
                }

                text: root.commandMode
                    ? "> "
                    : "Search applications..."

                color: Qt.rgba(1, 1, 1, 0.45)

                font.family: "JetBrains Mono"
                font.pixelSize: 14

                visible: !search.text
            }

            TextInput {
                id: search

                anchors {
                    fill: parent
                    leftMargin: 14
                    rightMargin: 14
                }

                color: "white"
                selectionColor: Qt.rgba(1, 1, 1, 0.2)

                font.family: "JetBrains Mono"
                font.pixelSize: 18

                verticalAlignment: TextInput.AlignVCenter

                onTextChanged: {
                    root.query = text
                    root.selectedIndex = 0
                    results.currentIndex = 0
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
                        results.currentItem?.activate()
                        event.accepted = true
                        break

                    case Qt.Key_Escape:
                        root.closed()
                        event.accepted = true
                        break
                    }
                }

                onVisibleChanged: {
                    if (visible)
                        Qt.callLater(() => search.forceActiveFocus())
                }
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
            height: parent.height - searchBox.height - 13

            currentIndex: root.selectedIndex

            clip: true
            spacing: 6

            model: root.commandMode
                ? root.commands
                : root.applications

            delegate: Item {
                id: delegateRoot

                required property var modelData

                width: results.width
                height: 64

                function activate() {
                    if (root.commandMode) {
                        root.commandRequested(modelData.id)
                    } else {
                        appEntry.activate()
                    }
                }

                LauncherApp {
                    id: appEntry

                    anchors.fill: parent

                    visible: !root.commandMode
                    app: delegateRoot.modelData

                    onLaunched: root.closed()
                }

                LauncherCommand {
                    anchors.fill: parent

                    visible: root.commandMode
                    command: delegateRoot.modelData

                    onTriggered: {
                        root.commandRequested(command.id)
                    }
                }
            }

            onCurrentIndexChanged: {
                root.selectedIndex = currentIndex
            }
        }
    }

    onVisibleChanged: {
        if (!visible)
            return

        root.query = ""
        root.selectedIndex = 0

        search.text = ""
        results.currentIndex = 0

        Qt.callLater(() => search.forceActiveFocus())
    }
}
