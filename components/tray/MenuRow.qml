/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Adapted from caelestia-dots/shell modules/bar/popouts/TrayMenu.qml (GPL-3.0):
 * one DBusMenu row in the tray option popout, retargeted from the Caelestia
 * Colours/Tokens singletons onto Solara Theme roles. Renders as a rounded M3
 * surface with a StateLayer, optional theme icon, checkbox/radio state and a
 * chevron for entries that expand into a submenu.
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../theme"
import ".."

StyledRect {
    id: root

    required property QsMenuEntry modelData

    signal openSubmenu(handle: var)
    signal dismiss()

    readonly property bool separator: root.modelData.isSeparator

    implicitWidth: 200
    width: 200
    height: root.separator ? 1 : 36
    radius: Theme.radiusL
    color: root.separator ? Theme.outlineVariant : "transparent"

    Loader {
        anchors.fill: parent
        active: !root.separator

        sourceComponent: Item {
            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                }

                spacing: 8

                IconImage {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    visible: source !== ""
                    source: root.modelData.icon
                }

                Text {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: root.modelData.text
                    elide: Text.ElideRight
                    color: root.modelData.enabled ? Theme.onSurface : Theme.outline
                    font {
                        family: Theme.fontFamily
                        pixelSize: 13
                    }
                }

                Item {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        visible: root.modelData.hasChildren
                        text: "\u203a"
                        color: Theme.onSurfaceVariant
                        font {
                            family: Theme.fontFamily
                            pixelSize: 15
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: root.modelData.buttonType === QsMenuButtonType.CheckBox
                        radius: 4
                        border {
                            width: 1.5
                            color: Theme.outline
                        }
                        color: root.modelData.checkState === Qt.Checked ? Theme.primary : "transparent"

                        Text {
                            anchors.centerIn: parent
                            visible: root.modelData.checkState === Qt.Checked
                            text: "\u2713"
                            color: Theme.onPrimary
                            font {
                                family: Theme.fontFamily
                                pixelSize: 10
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: root.modelData.buttonType === QsMenuButtonType.RadioButton
                        radius: 8
                        border {
                            width: 1.5
                            color: Theme.outline
                        }
                        color: "transparent"

                        Rectangle {
                            anchors.centerIn: parent
                            width: 8
                            height: 8
                            radius: 4
                            color: Theme.primary
                            visible: root.modelData.checkState === Qt.Checked
                        }
                    }
                }
            }

            StateLayer {
                anchors.fill: parent
                radius: root.radius
                disabled: root.separator

                onClicked: {
                    const entry = root.modelData
                    if (entry.hasChildren)
                        root.openSubmenu(entry)
                    else {
                        entry.triggered()
                        root.dismiss()
                    }
                }
            }
        }
    }
}