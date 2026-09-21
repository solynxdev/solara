import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking

import "../../services"
import "../../theme"
import "../../components"
import "../../components/controls"

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

    component ToggleButton: ButtonBase {
        id: toggle

        property string glyph
        property bool on: false

        implicitWidth: 44
        implicitHeight: 44

        type: ButtonBase.Tonal
        isRound: true

        checked: toggle.on
        activeColour: Theme.primary
        activeOnColour: Theme.onPrimary
        inactiveColour: hovered ? Theme.chipHover : Theme.surfaceVariant
        inactiveOnColour: Theme.text

        Text {
            anchors.centerIn: parent
            text: toggle.glyph
            color: toggle.onColour

            font.family: "Material Symbols Rounded"
            font.pixelSize: 20

            Behavior on color {
                CAnim {}
            }
        }

        ToolTip {
            visible: toggle.hovered
            text: toggle.glyph.replace("_", " ")
            delay: 500
        }
    }

    component ActionChip: ButtonBase {
        id: chip

        property string glyph
        property string label
        property bool interactive: true

        implicitWidth: row.implicitWidth + 20
        implicitHeight: 26

        type: ButtonBase.Tonal
        isRound: true
        radiusMorph: false

        inactiveColour: hovered ? Theme.chipHover : Theme.surfaceVariant
        activeColour: Theme.chipHover
        activeOnColour: Theme.textSecondary
        inactiveOnColour: Theme.textSecondary

        onClicked: {
            if (chip.interactive)
                chip.clicked()
        }

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 4

            Text {
                text: chip.glyph
                color: chip.onColour

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
    }
}