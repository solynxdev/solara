import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import "../services"
import "../theme"

// One workspace pill. The filled/active capsule morphs into one of several
// organic M3-style shapes (caelestia's dynamic indicator language) while
// the slate flattens to an outline chip. Empty workspaces rest as faint
// circles, occupied ones as squares, the active one slides into a longer pill.
Item {
    id: root

    required property var workspace
    required property int workspaceIndex

    readonly property bool active: root.workspace.active

    // Occupied = has at least one window.
    readonly property bool occupied:
        root.workspace.toplevels.count > 0

    implicitWidth: 22
    implicitHeight: 22

    // Caelestia dynamic indicator shapes (subset). Active pill morphs on focus.
    readonly property var dynamicShapes: [
        "pill", "oval", "square", "clover4Leaf", "clover6Leaf" ]

    readonly property int shapeIndex: {
        const idx = root.workspace.id % root.dynamicShapes.length;
        return idx;
    }

    // Traces an organic shape (one of the M3 glyphs) in the canvas context.
    function shapePath(ctx, s, w, h) {
        const cx = w / 2;
        const cy = h / 2;
        switch (s) {
        case "circle": {
            ctx.arc(cx, cy, w / 2 - 1, 0, Math.PI * 2);
            break;
        }
        case "square": {
            const sq = Math.min(w, h) * 0.62;
            ctx.rect((w - sq) / 2, (h - sq) / 2, sq, sq);
            break;
        }
        case "pill": {
            const r = h / 2;
            ctx.moveTo(r, 0);
            ctx.lineTo(w - r, 0);
            ctx.arc(w - r, cy, r, -Math.PI / 2, Math.PI / 2);
            ctx.lineTo(r, h);
            ctx.arc(r, cy, r, Math.PI / 2, Math.PI * 1.5);
            ctx.closePath();
            break;
        }
        case "oval": {
            ctx.save();
            ctx.translate(cx, cy);
            ctx.scale(1, h / w);
            ctx.arc(0, 0, w / 2 - 1, 0, Math.PI * 2);
            ctx.restore();
            break;
        }
        case "clover4Leaf": {
            const pr = w * 0.24;
            const off = pr * 0.72;
            for (const [dx, dy] of [ [0, -off], [off, 0], [0, off], [-off, 0] ])
                ctx.arc(cx + dx, cy + dy, pr, 0, Math.PI * 2);
            break;
        }
        case "clover6Leaf": {
            const r6 = w * 0.30;
            const o6 = r6 * 0.62;
            for (const [dx, dy] of [ [0, -o6], [o6 * 0.87, -o6 * 0.5], [o6 * 0.87, o6 * 0.5], [0, o6], [-o6 * 0.87, o6 * 0.5], [-o6 * 0.87, -o6 * 0.5] ])
                ctx.arc(cx + dx, cy + dy, r6, 0, Math.PI * 2);
            break;
        }
        default: {
            ctx.rect(1, 1, w - 2, h - 2);
        }
        }
    }

    Canvas {
        id: glyph

        width: root.active || root.occupied ? 16 : 6
        height: root.active ? 16 : 6
        anchors.centerIn: parent

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

        antialiasing: true

        property string shape: root.active
            ? root.dynamicShapes[root.shapeIndex]
            : root.occupied ? "square" : "circle"

        onShapeChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            const ctx = getContext("2d");
            ctx.beginPath();
            root.shapePath(ctx, glyph.shape, glyph.width, glyph.height);
            ctx.fillStyle = root.active ? Theme.accent : Qt.rgba(Theme.text.r, Theme.text.g, Theme.text.b, root.occupied ? 0.55 : 0.22);
            ctx.fill();
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