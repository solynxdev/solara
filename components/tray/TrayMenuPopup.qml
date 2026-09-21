/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Adapted from caelestia-dots/shell modules/bar/popouts/TrayMenu.qml (GPL-3.0):
 * the DBusMenu option popout for a hovered tray entry, retargeted from the
 * Caelestia Colours/Tokens singletons onto Solara Theme roles and motion.
 * Entries render as MenuRow surfaces; entries with children push onto the
 * view stack and a secondary-container pill pops back to the parent menu.
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../theme"
import "../../services"
import ".."

PopupWindow {
    id: root

    required property QsMenuHandle trayItem
    readonly property bool hovering: contentCovered.containsMouse

    visible: false
    color: "transparent"
    grabFocus: false

    readonly property real padding: 8

    implicitWidth: stack.implicitWidth + root.padding * 2
    implicitHeight: stack.implicitHeight + root.padding * 2

    function show() {
        while (stack.depth > 1)
            stack.pop()

        root.visible = true
    }

    function hide() {
        root.visible = false
    }

    MouseArea {
        id: contentCovered

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        StyledRect {
            id: panel

            anchors.fill: parent
            radius: Theme.radiusL
            color: Theme.surfaceContainerHighest
            border.width: 1
            border.color: Theme.outlineVariant

            StackView {
                id: stack

                anchors.fill: parent
                anchors.margins: root.padding

                implicitWidth: currentItem.implicitWidth
                implicitHeight: currentItem.implicitHeight

                pushEnter: NoAnim {}
                pushExit: NoAnim {}
                popEnter: NoAnim {}
                popExit: NoAnim {}

                initialItem: SubMenu {
                    isSubMenu: false
                    handle: root.trayItem
                }
            }
        }
    }

    component NoAnim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    component SubMenu: Column {
        id: submenu

        required property QsMenuHandle handle
        property bool isSubMenu: false
        property bool shown: false

        spacing: 0
        width: 200

        opacity: shown ? 1 : 0
        scale: shown ? 1 : 0.94

        Behavior on opacity {
            NumberAnimation {
                duration: AnimationManager.timings.fast
                easing.type: AnimationManager.easing.standard
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: AnimationManager.timings.fast
                easing.type: AnimationManager.easing.standard
            }
        }

        Component.onCompleted: shown = true

        QsMenuOpener {
            id: menuOpener

            menu: submenu.handle
        }

        Repeater {
            model: menuOpener.children

            delegate: MenuRow {
                onDismiss: root.hide()
                onOpenSubmenu: handle => stack.push(subMenuComp.createObject(null, {
                    handle: handle,
                    isSubMenu: true
                }))
            }
        }

        Loader {
            asynchronous: true
            active: submenu.isSubMenu

            sourceComponent: Item {
                implicitWidth: backRow.implicitWidth
                implicitHeight: backRow.implicitHeight

                StyledRect {
                    id: backRow

                    anchors.fill: parent
                    radius: Theme.radiusL
                    color: Theme.secondaryContainer

                    StateLayer {
                        radius: parent.radius
                        color: Theme.onSecondaryContainer
                        onClicked: stack.pop()
                    }

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 12
                            rightMargin: 12
                        }

                        spacing: 8

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "\u2039"
                            color: Theme.onSecondaryContainer
                            font {
                                family: Theme.fontFamily
                                pixelSize: 15
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: "Back"
                            color: Theme.onSecondaryContainer
                            font {
                                family: Theme.fontFamily
                                pixelSize: 13
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: subMenuComp

        SubMenu {}
    }
}