pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../../services"
import "../../theme"


Item {
    id: root

    property string query: ""
    property int selectedIndex: 0

    signal closed()

    implicitWidth: 700
    implicitHeight: 500

    readonly property var schemes: [
        {
            id: "catppuccin/latte",
            name: "Catppuccin Latte",
            description: "Light pastel theme",

            colors: {
                background: "#eff1f5",
                surface: "#e6e9ef",
                accent: "#8839ef",
                text: "#4c4f69"
            }
        },
        {
            id: "catppuccin/frappe",
            name: "Catppuccin Frappe",
            description: "Soft dark pastel theme",

            colors: {
                background: "#303446",
                surface: "#292c3c",
                accent: "#ca9ee6",
                text: "#c6d0f5"
            }
        },
        {
            id: "catppuccin/macchiato",
            name: "Catppuccin Macchiato",
            description: "Dark pastel theme",

            colors: {
                background: "#24273a",
                surface: "#1e2030",
                accent: "#c6a0f6",
                text: "#cad3f5"
            }
        },
        {
            id: "catppuccin/mocha",
            name: "Catppuccin Mocha",
            description: "Darkest Catppuccin theme",

            colors: {
                background: "#1e1e2e",
                surface: "#181825",
                accent: "#cba6f7",
                text: "#cdd6f4"
            }
        },
        {
            id: "dynamic",
            name: "Dynamic",
            description: "Generate colors from your wallpaper",

            colors: {
                background: "#202020",
                surface: "#303030",
                accent: "#888888",
                text: "#ffffff"
            }
        }
    ]

    readonly property var filteredSchemes: {
        const query = root.query.trim().toLowerCase()

        if (!query)
            return root.schemes

        return root.schemes.filter(scheme =>
            scheme.name.toLowerCase().includes(query)
            || scheme.description.toLowerCase().includes(query)
        )
    }

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

        Rectangle {
            width: parent.width
            height: 48

            radius: 14

            color: Qt.rgba(
                Theme.text.r,
                Theme.text.g,
                Theme.text.b,
                0.08
            )

            border.width: 1
            border.color: Qt.rgba(
                Theme.text.r,
                Theme.text.g,
                Theme.text.b,
                0.10
            )

            TextInput {
                id: search

                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 16
                }

                focus: true

                color: Theme.text
                selectionColor: Qt.rgba(
                    Theme.text.r,
                    Theme.text.g,
                    Theme.text.b,
                    0.2
                )

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

                text: "Search schemes..."
                color: Theme.textSecondary

                font.family: "JetBrains Mono"
                font.pixelSize: 16

                visible: search.text.length === 0
            }
        }

        Rectangle {
            width: parent.width
            height: 1

            color: Qt.rgba(
                Theme.text.r,
                Theme.text.g,
                Theme.text.b,
                0.15
            )
        }

        ListView {
            id: results

            width: parent.width
            height: parent.height - search.height - 13

            clip: true
            spacing: 6

            model: root.filteredSchemes
            currentIndex: root.selectedIndex

            delegate: SchemeItem {
                required property var modelData

                width: results.width
                height: 64

                scheme: modelData

                onSelected: id => {
                    ThemeManager.setScheme(id)
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
                results.currentItem.select()

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

    onEnabledChanged: {
        if (enabled)
            Qt.callLater(() => search.forceActiveFocus())
    }
}
