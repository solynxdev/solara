import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.SystemTray

Item {
    id: root

    property bool trayExpanded: false

    readonly property var wifiDevice: {
        return Networking.devices.values.find(
            device => device.type === DeviceType.Wifi
        ) ?? null
    }

    readonly property var bluetoothAdapter:
        Bluetooth.defaultAdapter

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

                source: Quickshell.iconPath(
                    "network-wireless"
                )

                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (Networking.wifiHardwareEnabled)
                        Networking.wifiEnabled =
                            !Networking.wifiEnabled
                }
            }
        }

        // Bluetooth
        Item {
            width: 22
            height: 22

            Image {
                anchors.fill: parent

                source: Quickshell.iconPath(
                    "bluetooth"
                )

                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (root.bluetoothAdapter)
                        root.bluetoothAdapter.enabled =
                            !root.bluetoothAdapter.enabled
                }
            }
        }

        // System tray toggle
        Item {
            width: 22
            height: 22

            Text {
                anchors.centerIn: parent

                text: root.trayExpanded ? "‹" : "⋯"

                color: "white"
                font.pixelSize: 18
                font.weight: Font.Bold
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    root.trayExpanded = !root.trayExpanded
                }
            }
        }

        // Expanded system tray
        Row {
            id: tray

            spacing: 4
            visible: root.trayExpanded

            Repeater {
                model: SystemTray.items

                delegate: Item {
                    required property var modelData

                    width: 24
                    height: 24

                    Image {
                        anchors.fill: parent

                        source: modelData.icon

                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            modelData.activate()
                        }
                    }

                    ToolTip {
                        visible: containsMouse
                        text: modelData.tooltipTitle
                            || modelData.title
                    }
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }
}
