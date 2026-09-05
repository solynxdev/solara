import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

import "../theme"

// Right-side clause of the bar: a pill container that always shows every
// daemonized SystemTray app (no hidden overflow). Wi-Fi and Bluetooth
// toggles live in the expanded notch quick-settings instead.
Item {
    id: root

    readonly property bool trayHasItems: SystemTray.items.count > 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 6

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