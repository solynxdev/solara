pragma Singleton

import QtQuick

import "../services"

QtObject {
    id: root

    readonly property string fontFamily: "Sans"
    readonly property color background: ThemeManager.color("background", "#1e1e2e")
    readonly property color chrome: ThemeManager.color("chrome", "#11111b")
    readonly property color surface: ThemeManager.color("surface", "#181825")
    readonly property color surfaceVariant: ThemeManager.color("surfaceVariant", "#313244")
    readonly property color text: ThemeManager.color("text", "#cdd6f4")
    readonly property color textSecondary: ThemeManager.color("textSecondary", "#bac2de")
    readonly property color accent: ThemeManager.color("accent", "#cba6f7")
    readonly property color accentText: ThemeManager.color("accentText", "#1e1e2e")
    readonly property color border: ThemeManager.color("border", "#45475a")
    readonly property color red: ThemeManager.color("red", "#f38ba8")
    readonly property color green: ThemeManager.color("green", "#a6e3a1")
    readonly property color yellow: ThemeManager.color("yellow", "#f9e2af")
    readonly property color blue: ThemeManager.color("blue", "#89b4fa")
    readonly property color purple: ThemeManager.color("purple", "#cba6f7")
    readonly property color cyan: ThemeManager.color("cyan", "#94e2d5")
    readonly property color overlay: ThemeManager.color("overlay", "#6c7086")
    readonly property color selection: ThemeManager.color("selection", "#45475a")
    readonly property color shadow: ThemeManager.color("shadow", "#11111b")

    // ---- Glass material ----
    readonly property bool glassEnabled: ConfigManager.get("glass.effect", true)

    readonly property int glassBlurRadius: {
        switch (ConfigManager.get("glass.quality", "balanced")) {
        case "max":
            return 36;
        case "minimal":
            return 0;
        case "off":
            return 0;
        default:
            return 24;
        }
    }

    readonly property bool glassLight: root.background.hslLightness >= 0.5

    // Tint gradient (top -> mid -> bottom). With the effect on, translucent
    // neutrals let the compositor blur dominate; light modes lean opaque
    // white. With the effect off, resolve to solid scheme surfaces
    // (Apple's reduced-transparency fallback).
    readonly property color glassTop: root.glassEnabled ? (root.glassLight ? Qt.rgba(1, 1, 1, 0.94) : Qt.rgba(1, 1, 1, 0.16)) : root.surface
    readonly property color glassMid: root.glassEnabled ? (root.glassLight ? Qt.rgba(1, 1, 1, 0.68) : Qt.rgba(1, 1, 1, 0.05)) : root.surface
    readonly property color glassBottom: root.glassEnabled ? (root.glassLight ? Qt.rgba(1, 1, 1, 0.42) : Qt.rgba(0, 0, 0, 0.30)) : root.surfaceVariant

    // Full-perimeter specular edge (neutral) + wallpaper-hue edge (top catch).
    readonly property color glassRim: root.glassEnabled ? Qt.rgba(1, 1, 1, root.glassLight ? 0.60 : 0.20) : Qt.rgba(0, 0, 0, 0)
    readonly property color glassEdge: root.glassEnabled ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, root.glassLight ? 0.55 : 0.30) : Qt.rgba(0, 0, 0, 0)
    readonly property color glassGlow: root.glassEnabled ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, root.glassLight ? 0.18 : 0.22) : Qt.rgba(0, 0, 0, 0)

    // Coat for overlay panels that morph inside the island: keeps content
    // readable while the sheet morphs and when the compositor has no blur,
    // without fully covering the glass underneath.
    readonly property color glassPanel: root.glassLight ? Qt.rgba(0.95, 0.95, 1.0, 0.50) : Qt.rgba(0.08, 0.08, 0.12, 0.42)

    // Android-style status-bar scrim: translucent dark so the compositor
    // blur (BackgroundEffect.blurRegion on the notch window) shows through.
    readonly property color notchScrim: root.glassLight ? Qt.rgba(0.96, 0.96, 0.98, 0.72) : Qt.rgba(0.02, 0.02, 0.05, 0.65)

    // ---- Material 3 / caffyne roles ----
    readonly property color primary: root.accent
    readonly property color onPrimary: root.accentText
    readonly property color surfaceDim: root.mix(root.surface, root.shadow, 0.32)

    readonly property color surfaceContainerLowest: root.mix(root.surface, root.surfaceVariant, 0.10)
    readonly property color surfaceContainerLow: root.mix(root.surface, root.surfaceVariant, 0.42)
    readonly property color surfaceContainer: root.mix(root.surface, root.surfaceVariant, 0.78)
    readonly property color surfaceContainerHigh: root.mix(root.surfaceVariant, root.text, 0.12)
    readonly property color surfaceContainerHighest: root.mix(root.surfaceVariant, root.text, 0.32)

    readonly property color outline: root.mix(root.surfaceVariant, root.text, 0.45)
    readonly property color outlineVariant: root.mix(root.surfaceVariant, root.text, 0.70)

    readonly property color scrim: Qt.rgba(0, 0, 0, 0.45)

    // Material "surface container" chips (caffyne-style widgets).
    readonly property color chip: root.surfaceContainer
    readonly property color chipHover: root.surfaceContainerHigh
    readonly property color chipActive: root.mix(root.accent, root.surface, 0.40)
    // "Applet open" state = surface_container_highest.
    readonly property color chipOpen: root.surfaceContainerHighest

    // ---- Material 3 secondary/tertiary container roles (warm, bright) ----
    // Derived from the scheme's accent palette so the abstract desktop/dash
    // shapes pick up warm, vivid tints regardless of the base scheme.
    readonly property color primaryContainer: root.mix(root.accent, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.72 : 0.28)
    readonly property color onPrimaryContainer: root.mix(root.accent, root.glassLight ? "#000000" : "#ffffff", 0.55)
    readonly property color secondary: root.purple
    readonly property color secondaryContainer: root.mix(root.purple, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.72 : 0.30)
    readonly property color onSecondaryContainer: root.mix(root.purple, root.glassLight ? "#000000" : "#ffffff", 0.50)
    readonly property color tertiary: root.cyan
    readonly property color tertiaryContainer: root.mix(root.cyan, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.74 : 0.30)
    readonly property color onTertiaryContainer: root.mix(root.cyan, root.glassLight ? "#000000" : "#ffffff", 0.50)

    // Material 3 radius scale.
    readonly property real radiusS: 6
    readonly property real radiusM: 10
    readonly property real radiusL: 20
    readonly property real radiusXL: 28

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t,
            a.g + (b.g - a.g) * t,
            a.b + (b.b - a.b) * t,
            1)
    }
}
