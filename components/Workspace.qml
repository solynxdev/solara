import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import "../services"
import "../theme"

// One workspace dot. Circles only: the active workspace is an accent-filled
// circle that swells, occupied workspaces rest as mid-opacity circles and
// empty ones as faint dots.
Item {
    id: root

    required property var workspace
    required property int workspaceIndex

    readonly property bool active: root.workspace.active

    readonly property bool occupied:
        root.workspace.toplevels.count > 0

    property real size: root.active ? 14 : root.occupied ? 10 : 6

    implicitWidth: 22
    implicitHeight: 22

    Rectangle {
        id: dot

        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: root.size / 2

        color: root.active
            ? Theme.accent
            : Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, root.occupied ? 0.55 : 0.22)

        Behavior on width {
            NumberAnimation {
                duration: AnimationManager.indicator.duration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: AnimationManager.indicator.duration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on radius {
            NumberAnimation {
                duration: AnimationManager.indicator.duration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on color {
            CAnim {}
        }
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        onTapped: Hyprland.dispatch("workspace " + root.workspace.id)
    }

    ToolTip {
        visible: hover.hovered
        text: qsTr("Workspace %1").arg(root.workspace.id)
        delay: 600
    }
}