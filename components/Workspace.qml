import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import "../services"
import "../theme"

// One workspace dot. Four states: the active workspace with windows is an
// accent-filled circle that swells; the active-but-empty workspace keeps the
// active size but falls back to the dimmed grey; occupied workspaces rest as
// mid-opacity circles and empty ones as faint dots.
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

        color: root.active && root.occupied
            ? Theme.accent
            : Qt.alpha(Theme.onSurfaceVariant, root.occupied ? 1 : 0.45)

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

    StateLayer {
        id: overlay

        anchors.centerIn: parent
        width: Math.max(root.size + 12, 18)
        height: Math.max(root.size + 12, 18)
        radius: width / 2
        cursorShape: Qt.PointingHandCursor

        onClicked: Hyprland.dispatch("workspace " + root.workspace.id)
    }

    HoverHandler {
        id: hover
    }

    ToolTip {
        visible: hover.hovered
        text: qsTr("Workspace %1").arg(root.workspace.id)
        delay: 600
    }
}