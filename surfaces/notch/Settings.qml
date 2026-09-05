import QtQuick
import QtQuick.Layouts

import "../../components"
import "../../components/controls"
import "../../services"
import "../../theme"

Item {
    id: root

    property int section: 0
    readonly property var navItems: [{
        "title": "Appearance"
    }, {
        "title": "Workspaces"
    }, {
        "title": "Bar"
    }, {
        "title": "Notch"
    }, {
        "title": "About"
    }]
    readonly property var schemes: [{
        "id": "catppuccin/latte",
        "name": "Latte",
        "colors": {
            "surface": "#e6e9ef",
            "accent": "#8839ef",
            "text": "#4c4f69"
        }
    }, {
        "id": "catppuccin/frappe",
        "name": "Frappe",
        "colors": {
            "surface": "#292c3c",
            "accent": "#ca9ee6",
            "text": "#c6d0f5"
        }
    }, {
        "id": "catppuccin/macchiato",
        "name": "Macchiato",
        "colors": {
            "surface": "#1e2030",
            "accent": "#c6a0f6",
            "text": "#cad3f5"
        }
    }, {
        "id": "catppuccin/mocha",
        "name": "Mocha",
        "colors": {
            "surface": "#181825",
            "accent": "#cba6f7",
            "text": "#cdd6f4"
        }
    }, {
        "id": "dynamic",
        "name": "Dynamic",
        "colors": {
            "surface": "#303030",
            "accent": "#888888",
            "text": "#ffffff"
        }
    }]
    readonly property string currentScheme: ConfigManager.get("scheme", "catppuccin/mocha")

    signal closed()

    implicitWidth: 700
    implicitHeight: 500
    Keys.onEscapePressed: root.closed()
    Component.onCompleted: forceActiveFocus()
    onEnabledChanged: {
        if (enabled)
            forceActiveFocus();

    }

    Rectangle {
        anchors.fill: parent
        radius: 24
        color: Theme.surface
    }

    Row {
        spacing: 14

        anchors {
            fill: parent
            margins: 20
        }

        Column {
            width: 140
            spacing: 8

            Text {
                text: "Solara"
                color: Theme.text

                font {
                    family: Theme.fontFamily
                    pixelSize: 16
                    bold: true
                }

            }

            Text {
                text: "Settings"
                color: Theme.textSecondary

                font {
                    family: Theme.fontFamily
                    pixelSize: 11
                }

            }

            Item {
                height: 8
            }

            Repeater {
                model: root.navItems

                delegate: Item {
                    required property var modelData
                    required property int index

                    width: 140
                    height: 34

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: root.section === index ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.16) : "transparent"
                        border.width: root.section === index ? 1 : 0
                        border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.5)
                    }

                    Text {
                        text: modelData.title
                        color: root.section === index ? Theme.accent : Theme.textSecondary

                        anchors {
                            left: parent.left
                            leftMargin: 12
                            verticalCenter: parent.verticalCenter
                        }

                        font {
                            family: Theme.fontFamily
                            pixelSize: 12
                        }

                    }

                    TapHandler {
                        onTapped: {
                            root.section = index;
                        }
                    }

                }

            }

        }

        Rectangle {
            width: 1
            height: parent.height
            color: Theme.border
            opacity: 0.5
        }

        StackLayout {
            id: stack

            width: parent.width - 140 - 15
            height: parent.height
            currentIndex: root.section

            Item {
                id: appearanceSection

                Column {
                    anchors.fill: parent
                    spacing: 10

                    SectionHeader {
                        title: "Appearance"
                        subtitle: "Scheme, material and animation feel"
                    }

                    Rectangle {
                        width: parent.width
                        height: 96
                        radius: 14
                        color: Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, 0.04)

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8

                            Text {
                                text: "Theme scheme"
                                color: Theme.text

                                font {
                                    family: Theme.fontFamily
                                    pixelSize: 13
                                }

                            }

                            Row {
                                spacing: 10

                                Repeater {
                                    model: root.schemes

                                    delegate: Column {
                                        required property var modelData

                                        spacing: 4

                                        Rectangle {
                                            width: 48
                                            height: 48
                                            radius: 12
                                            color: modelData.colors.surface
                                            border.width: root.currentScheme === modelData.id ? 2 : 1
                                            border.color: root.currentScheme === modelData.id ? Theme.accent : Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, 0.2)

                                            Rectangle {
                                                width: 12
                                                height: 4
                                                radius: 2
                                                color: modelData.colors.accent

                                                anchors {
                                                    bottom: parent.bottom
                                                    horizontalCenter: parent.horizontalCenter
                                                }

                                            }

                                            TapHandler {
                                                onTapped: {
                                                    ThemeManager.setScheme(modelData.id);
                                                }
                                            }

                                        }

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.name
                                            color: root.currentScheme === modelData.id ? Theme.accent : Theme.textSecondary

                                            font {
                                                family: Theme.fontFamily
                                                pixelSize: 8
                                            }

                                        }

                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: appearanceRows

                        width: parent.width
                        color: "transparent"

                        Column {
                            anchors.fill: parent
                            spacing: 2

                            SettingRow {
                                label: "Notch material"
                                hint: "Theme chrome or hard black to blend into the monitor"

                                control: SegmentedControl {
                                    id: notchStyleControl

                                    width: 150
                                    options: ["Theme", "Monitor"]
                                    index: ConfigManager.get("notch.style", "chrome") === "monitor" ? 1 : 0
                                    onChanged: {
                                        ConfigManager.set("notch.style", index === 1 ? "monitor" : "chrome");
                                    }
                                }

                            }

                            SettingRow {
                                label: "Animations"
                                hint: "Morph transitions across the shell"

                                control: Toggle {
                                    checked: ConfigManager.get("animations.enabled", true)
                                    onToggled: {
                                        ConfigManager.set("animations.enabled", checked);
                                    }
                                }

                            }

                            SettingRow {
                                label: "Notch animation (ms)"
                                hint: "Speed of the notch morph window"

                                control: Slider {
                                    width: 180
                                    from: 80
                                    to: 600
                                    stepSize: 10
                                    value: ConfigManager.get("animations.notch.duration", 250)
                                    onEditingFinished: {
                                        ConfigManager.set("animations.notch.duration", value);
                                    }
                                }

                            }

                        }

                    }

                }

            }

            Item {
                id: workspacesSection

                Column {
                    anchors.fill: parent
                    spacing: 10

                    SectionHeader {
                        title: "Workspaces"
                        subtitle: "Desktops and their visibility"
                    }

                    SettingRow {
                        width: stack.width
                        label: "Workspace count (" + ConfigManager.get("workspaces.count", 5) + ")"
                        hint: "Number of workspaces arranged across screens"

                        control: Slider {
                            width: 180
                            from: 1
                            to: 10
                            stepSize: 1
                            value: ConfigManager.get("workspaces.count", 5)
                            onEditingFinished: {
                                ConfigManager.set("workspaces.count", value);
                            }
                        }

                    }

                    SettingRow {
                        width: stack.width
                        label: "Show empty workspaces"
                        hint: "Keep empty desktops visible in the bar"

                        control: Toggle {
                            checked: ConfigManager.get("workspaces.showEmpty", false)
                            onToggled: {
                                ConfigManager.set("workspaces.showEmpty", checked);
                            }
                        }

                    }

                }

            }

            Item {
                id: barSection

                Column {
                    anchors.fill: parent
                    spacing: 10

                    SectionHeader {
                        title: "Bar"
                        subtitle: "Bottom status bar"
                    }

                    SettingRow {
                        width: stack.width
                        label: "Show bottom bar"
                        hint: "Clock, workspaces and system tray"

                        control: Toggle {
                            checked: ConfigManager.get("bar.enabled", true)
                            onToggled: {
                                ConfigManager.set("bar.enabled", checked);
                            }
                        }

                    }

                }

            }

            Item {
                id: notchSection

                Column {
                    anchors.fill: parent
                    spacing: 10

                    SectionHeader {
                        title: "Notch"
                        subtitle: "Shape and spacing of the dynamic island"
                    }

                    SettingRow {
                        width: stack.width
                        label: "Corner size (" + ConfigManager.get("notch.cornerSize", 24) + "px)"
                        hint: "Radius of the notch corners"

                        control: Slider {
                            width: 180
                            from: 8
                            to: 48
                            stepSize: 1
                            value: ConfigManager.get("notch.cornerSize", 24)
                            onEditingFinished: {
                                ConfigManager.set("notch.cornerSize", value);
                            }
                        }

                    }

                    SettingRow {
                        width: stack.width
                        label: "Horizontal padding (" + ConfigManager.get("notch.contentPaddingX", 20) + "px)"
                        hint: "Space to the left and right of notch content"

                        control: Slider {
                            width: 180
                            from: 4
                            to: 40
                            stepSize: 1
                            value: ConfigManager.get("notch.contentPaddingX", 20)
                            onEditingFinished: {
                                ConfigManager.set("notch.contentPaddingX", value);
                            }
                        }

                    }

                    SettingRow {
                        width: stack.width
                        label: "Vertical padding (" + ConfigManager.get("notch.contentPaddingY", 5) + "px)"
                        hint: "Space above and below notch content"

                        control: Slider {
                            width: 180
                            from: 0
                            to: 16
                            stepSize: 1
                            value: ConfigManager.get("notch.contentPaddingY", 5)
                            onEditingFinished: {
                                ConfigManager.set("notch.contentPaddingY", value);
                            }
                        }

                    }

                }

            }

            Item {
                id: aboutSection

                Column {
                    anchors.fill: parent
                    spacing: 10

                    SectionHeader {
                        title: "About"
                        subtitle: "Solara desktop shell for Hyprland"
                    }

                    Rectangle {
                        width: parent.width
                        implicitHeight: 150
                        radius: 14
                        color: Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, 0.04)

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8

                            Text {
                                text: "Configuration"
                                color: Theme.text

                                font {
                                    family: Theme.fontFamily
                                    pixelSize: 13
                                    bold: true
                                }

                            }

                            Text {
                                width: parent.width
                                wrapMode: Text.WordWrap
                                text: "This panel writes to config.json " + "(~/.config/solara/config.json). You can edit " + "that file directly too - both stay in sync and " + "reload live while the shell is running."
                                color: Theme.textSecondary

                                font {
                                    family: Theme.fontFamily
                                    pixelSize: 11
                                }

                            }

                            Text {
                                text: "Rendered with Quickshell over Hyprland."
                                color: Theme.textSecondary

                                font {
                                    family: Theme.fontFamily
                                    pixelSize: 11
                                }

                            }

                        }

                    }

                    Rectangle {
                        width: 160
                        height: 40
                        radius: 12
                        color: Qt.rgba(Theme.red.r, Theme.red.g, Theme.red.b, 0.14)
                        border.width: 1
                        border.color: Qt.rgba(Theme.red.r, Theme.red.g, Theme.red.b, 0.4)

                        Text {
                            anchors.centerIn: parent
                            text: "Reset all settings"
                            color: Theme.red

                            font {
                                family: Theme.fontFamily
                                pixelSize: 12
                            }

                        }

                        TapHandler {
                            onTapped: {
                                ConfigManager.reset();
                            }
                        }

                    }

                }

            }

        }

    }

    component SectionHeader: Column {
        property string title: ""
        property string subtitle: ""

        spacing: 2

        Text {
            text: title
            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: 16
                bold: true
            }

        }

        Text {
            text: subtitle
            color: Theme.textSecondary

            font {
                family: Theme.fontFamily
                pixelSize: 10
            }

        }

    }

}
