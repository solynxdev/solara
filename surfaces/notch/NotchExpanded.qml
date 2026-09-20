import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking

import "../../services"
import "../../theme"

// Caelestia-style "expanded" state of the dynamic island: a quick-settings
// panel. Clock/date header, a pill of icon toggles (wifi, bluetooth, settings,
// search) and actionable chips for the shell surfaces. Shapes, surface roles
// and animations mirror caelestia's material language (surfaceContainer cards,
// m3primary toggle fill, glyphs from Material Symbols Rounded).
Item {
    id: root

    signal requestMode(string mode)

    readonly property var bluetoothAdapter:
        Bluetooth.defaultAdapter

    readonly property bool wifiOn:
        Networking.wifiEnabled && Networking.wifiHardwareEnabled

    implicitWidth: 360
    implicitHeight: 224

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 14

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 1

            SystemClock {
                id: clockTime

                precision: SystemClock.Minutes
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(clockTime.date, "hh:mm")
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 44
                font.weight: Font.Medium
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Qt.formatDateTime(clockTime.date, "dddd, MMMM d")
                color: Theme.textSecondary
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 6

                width: 26
                height: 3
                radius: 1.5
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.55)
            }
        }

        // Quick toggles — one pill containing round icon buttons.
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter

            width: 208
            height: 54
            radius: 27
            color: Theme.chip

            Row {
                anchors.centerIn: parent
                spacing: 4

                ToggleButton {
                    glyph: "wifi"
                    on: root.wifiOn
                    onClicked: {
                        if (Networking.wifiHardwareEnabled)
                            Networking.wifiEnabled = !Networking.wifiEnabled
                    }
                }

                ToggleButton {
                    glyph: "bluetooth"
                    on: root.bluetoothAdapter && root.bluetoothAdapter.enabled
                    onClicked: {
                        const adapter = root.bluetoothAdapter;

                        if (adapter)
                            adapter.enabled = !adapter.enabled
                    }
                }

                ToggleButton {
                    glyph: "settings"
                    onClicked: root.requestMode("settings")
                }

                ToggleButton {
                    glyph: "search"
                    onClicked: root.requestMode("launcher")
                }
            }
        }

        // Surface shortcuts.
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            ActionChip {
                glyph: "wallpaper"
                label: "Wallpaper"
                onClicked: root.requestMode("wallpaper")
            }

            ActionChip {
                glyph: "palette"
                label: "Scheme"
                onClicked: root.requestMode("scheme")
            }

            ActionChip {
                glyph: ""
                label: ThemeManager.currentName
                interactive: false
            }
        }
    }

    component ToggleButton: Item {
        id: toggle

        property string glyph
        property bool on: false
        signal clicked()

        width: 44
        height: 44

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: toggle.on
                ? Theme.primary
                : (hover.hovered ? Theme.chipHover : Theme.surfaceVariant)

            Behavior on color {
                CAnim {}
            }
        }

        Text {
            anchors.centerIn: parent
            text: toggle.glyph
            color: toggle.on ? Theme.onPrimary : Theme.text
            font.family: "Material Symbols Rounded"
            font.pixelSize: 20

            Behavior on color {
                CAnim {}
            }
        }

        HoverHandler {
            id: hover
        }

        TapHandler {
            onTapped: toggle.clicked()
        }

        ToolTip {
            visible: hover.hovered
            text: toggle.glyph.replace("_", " ")
            delay: 500
        }
    }

    component ActionChip: Item {
        id: chip

        property string glyph
        property string label
        property bool interactive: true
        signal clicked()

        implicitWidth: row.implicitWidth + 18
        implicitHeight: 26

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: hover.hovered ? Theme.chipHover : Theme.surfaceVariant

            Behavior on color {
                CAnim {}
            }
        }

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 4

            Text {
                text: chip.glyph
                color: Theme.text
                font.family: "Material Symbols Rounded"
                font.pixelSize: 13
                visible: chip.glyph !== ""
            }

            Text {
                text: chip.label
                color: Theme.textSecondary
                font.family: Theme.fontFamily
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }

        HoverHandler {
            id: hover

            enabled: chip.interactive
        }

        TapHandler {
            enabled: chip.interactive
            onTapped: chip.clicked()
        }
    }
}