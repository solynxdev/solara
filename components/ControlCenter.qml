import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../theme"
import "tray"

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
            implicitHeight: 30

            Rectangle {
                id: trayPill

                width: trayRow.implicitWidth + 8
                height: 30
                radius: height / 2
                color: Theme.surfaceContainer
            }

            Row {
                id: trayRow

                anchors.centerIn: trayPill
                spacing: 2

                Repeater {
                    model: SystemTray.items

                    delegate: TrayItem {}
                }
            }
        }
    }
}