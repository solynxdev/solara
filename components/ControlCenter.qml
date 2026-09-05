import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.SystemTray

import "../theme"

// Right-side clause of the bar: status chips (wifi, bluetooth) plus a
// container that always shows every daemonized SystemTray app (no hidden
// overflow). Chips carry caelestia-style state: the wifi glyph reflects
// signal strength, bluetooth dims when powered off.
Item {
    id: root

    readonly property var bluetoothAdapter:
        Bluetooth.defaultAdapter

    readonly property var wifiDevice: {
        const devices = Networking.devices;
        for (let i = 0; i < devices.count; ++i) {
            const d = devices.get(i);
            if (d instanceof WifiDevice)
                return d;
        }

        return null;
    }

    readonly property var activeWifi: {
        if (!root.wifiDevice)
            return null;

        const networks = root.wifiDevice.networks;
        for (let i = 0; i < networks.count; ++i) {
            const n = networks.get(i);
            if (n.connected)
                return n;
        }

        return null;
    }

    readonly property real wifiStrength:
        root.activeWifi ? root.activeWifi.signalStrength : -1

    readonly property bool wifiOn:
        Networking.wifiEnabled && Networking.wifiHardwareEnabled

    readonly property string wifiIcon: {
        if (!Networking.wifiHardwareEnabled || !Networking.wifiEnabled)
            return "network-wireless-off";

        if (root.wifiStrength >= 75)
            return "network-wireless-signal-good";
        if (root.wifiStrength >= 50)
            return "network-wireless-signal-ok";
        if (root.wifiStrength >= 25)
            return "network-wireless-signal-weak";
        return "network-wireless-signal-none";
    }

    readonly property bool trayHasItems: SystemTray.items.count > 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 6

        // Wi-Fi
        Item {
            width: 22
            height: 22

            Image {
                anchors.fill: parent
                source: Quickshell.iconPath(root.wifiIcon)
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: root.wifiOn ? 1 : 0.4
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (Networking.wifiHardwareEnabled)
                        Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }

            HoverHandler {
                id: wifiHover
            }

            ToolTip {
                visible: wifiHover.hovered
                text: root.wifiOn
                    ? "Wi-Fi on" + (root.activeWifi ? " · " + root.activeWifi.name : "")
                    : "Wi-Fi off"
                delay: 500
            }
        }

        // Bluetooth
        Item {
            width: 22
            height: 22

            readonly property bool powered:
                root.bluetoothAdapter && root.bluetoothAdapter.enabled

            Image {
                anchors.fill: parent
                source: Quickshell.iconPath(
                    root.bluetoothAdapter && root.bluetoothAdapter.enabled
                        ? "bluetooth"
                        : "bluetooth-disabled"
                )

                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: parent.powered ? 1 : 0.4
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (root.bluetoothAdapter)
                        root.bluetoothAdapter.enabled =
                            !root.bluetoothAdapter.enabled
                }
            }

            HoverHandler {
                id: bluetoothHover
            }

            ToolTip {
                visible: bluetoothHover.hovered
                text: parent.powered ? "Bluetooth on" : "Bluetooth off"
                delay: 500
            }
        }

        // System tray → a container that always shows all daemonized apps.
        Item {
            id: trayContainer

            visible: root.trayHasItems
            implicitWidth: visible ? trayPill.width : 0
            implicitHeight: 24

            Rectangle {
                id: trayPill

                width: trayRow.implicitWidth + 8
                height: 24
                radius: height / 2
                color: Theme.surfaceContainer
            }

            Row {
                id: trayRow

                anchors.centerIn: trayPill
                spacing: 2

                Repeater {
                    model: SystemTray.items

                    delegate: Item {
                        required property var modelData

                        width: 20
                        height: 20

                        Image {
                            anchors.fill: parent
                            source: modelData.icon
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            visible: modelData.icon !== ""
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: {
                                if (mouse.button === Qt.RightButton)
                                    modelData.secondaryActivate()
                                else
                                    modelData.activate()
                            }
                        }

                        HoverHandler {
                            id: trayHover
                        }

                        ToolTip {
                            visible: trayHover.hovered
                            text: modelData.tooltipTitle
                                || modelData.title
                            delay: 500
                        }
                    }
                }
            }
        }
    }
}