/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Bar entry for a daemonized SystemTray app. Hovering pops the
 * caelestia-style option menu (TrayMenuPopup) out below the icon; left
 * click activates the app and right click sends secondaryActivate, matching
 * Caelestia's TrayItem semantics. Apps with no menu stay click-to-activate.
 */

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../../theme"

MouseArea {
    id: root

    required property SystemTrayItem modelData

    implicitWidth: 26
    implicitHeight: 26
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor

    readonly property bool canPop: root.modelData.hasMenu || root.modelData.onlyMenu

    IconImage {
        anchors.fill: parent
        anchors.margins: 3
        visible: source !== ""
        source: root.modelData.icon
    }

    onClicked: {
        if (mouse.button === Qt.RightButton) {
            if (root.canPop)
                popup.show()

            root.modelData.secondaryActivate()
        } else if (root.modelData.onlyMenu) {
            popup.show()
        } else {
            root.modelData.activate()
        }
    }

    // Hover summons the option popout; the keeper keeps it alive while the
    // pointer travels from the icon into the popup, then tucks it away.
    Timer {
        id: openTimer

        interval: 320

        onTriggered: {
            if (root.containsMouse && root.canPop)
                popup.show()
        }
    }

    Timer {
        id: keeper

        interval: 100
        repeat: true
        running: popup.visible

        onTriggered: {
            if (!root.containsMouse && !popup.hovering)
                popup.hide()
        }
    }

    onEntered: openTimer.start()
    onExited: openTimer.stop()

    TrayMenuPopup {
        id: popup

        visible: false
        trayItem: root.modelData.menu

        anchor {
            window: root.QsWindow.window
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }
    }
}