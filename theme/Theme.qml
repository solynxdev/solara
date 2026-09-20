/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Theme surface. Legacy flat names (background, surface, text, ...) remain
 * byte-for-byte stable for consumers; Material 3 role names read from the
 * active scheme's role set (or the matugen ColorManager for "dynamic").
 * Every derived alias keeps its previous inline formula as a fallback so a
 * scheme without a given role degrades gracefully to the old behaviour.
 */

pragma Singleton

import QtQuick

import "../services"

QtObject {
    id: root

    readonly property string fontFamily: "Sans"

    // ---- Legacy flat surface (stable for consumers) ----
    readonly property color background: root.color("background", "#1e1e2e")
    readonly property color chrome: root.color("chrome", "#11111b")
    readonly property color surface: root.color("surface", "#181825")
    readonly property color surfaceVariant: root.color("surfaceVariant", "#313244")
    readonly property color text: root.color("text", "#cdd6f4")
    readonly property color textSecondary: root.color("textSecondary", "#bac2de")
    readonly property color accent: root.color("accent", "#cba6f7")
    readonly property color accentText: root.color("accentText", "#1e1e2e")
    readonly property color border: root.color("border", "#45475a")
    readonly property color red: root.color("red", "#f38ba8")
    readonly property color green: root.color("green", "#a6e3a1")
    readonly property color yellow: root.color("yellow", "#f9e2af")
    readonly property color blue: root.color("blue", "#89b4fa")
    readonly property color purple: root.color("purple", "#cba6f7")
    readonly property color cyan: root.color("cyan", "#94e2d5")
    readonly property color overlay: root.color("overlay", "#6c7086")
    readonly property color selection: root.color("selection", "#45475a")
    readonly property color shadow: root.color("shadow", "#11111b")

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

    // ---- Material 3 roles (from scheme role sets, old formulas as fallback) ----
    readonly property color primary: root.role("primary", root.accent)
    readonly property color onPrimary: root.role("onPrimary", root.accentText)
    readonly property color surfaceDim: root.role("surfaceDim", root.mix(root.surface, root.shadow, 0.32))

    readonly property color surfaceContainerLowest: root.role("surfaceContainerLowest", root.mix(root.surface, root.surfaceVariant, 0.10))
    readonly property color surfaceContainerLow: root.role("surfaceContainerLow", root.mix(root.surface, root.surfaceVariant, 0.42))
    readonly property color surfaceContainer: root.role("surfaceContainer", root.mix(root.surface, root.surfaceVariant, 0.78))
    readonly property color surfaceContainerHigh: root.role("surfaceContainerHigh", root.mix(root.surfaceVariant, root.text, 0.12))
    readonly property color surfaceContainerHighest: root.role("surfaceContainerHighest", root.mix(root.surfaceVariant, root.text, 0.32))

    readonly property color outline: root.role("outline", root.mix(root.surfaceVariant, root.text, 0.45))
    readonly property color outlineVariant: root.role("outlineVariant", root.mix(root.surfaceVariant, root.text, 0.70))

    readonly property color scrim: Qt.rgba(0, 0, 0, 0.45)

    // Material "surface container" chips (caffyne-style widgets).
    readonly property color chip: root.surfaceContainer
    readonly property color chipHover: root.surfaceContainerHigh
    readonly property color chipActive: root.mix(root.accent, root.surface, 0.40)
    // "Applet open" state = surface_container_highest.
    readonly property color chipOpen: root.surfaceContainerHighest

    // Material 3 secondary/tertiary/error roles.
    readonly property color secondary: root.role("secondary", root.purple)
    readonly property color tertiary: root.role("tertiary", root.cyan)
    readonly property color error: root.role("error", root.red)
    readonly property color onError: root.role("onError", root.mix(root.red, "#ffffff", 0.75))
    readonly property color errorContainer: root.role("errorContainer", root.mix(root.red, root.surface, 0.45))
    readonly property color onErrorContainer: root.role("onErrorContainer", root.mix(root.red, root.surface, 0.62))

    readonly property color primaryContainer: root.role("primaryContainer", root.mix(root.accent, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.72 : 0.28))
    readonly property color onPrimaryContainer: root.role("onPrimaryContainer", root.mix(root.accent, root.glassLight ? "#000000" : "#ffffff", 0.55))
    readonly property color secondaryContainer: root.role("secondaryContainer", root.mix(root.secondary, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.72 : 0.30))
    readonly property color onSecondaryContainer: root.role("onSecondaryContainer", root.mix(root.secondary, root.glassLight ? "#000000" : "#ffffff", 0.50))
    readonly property color tertiaryContainer: root.role("tertiaryContainer", root.mix(root.cyan, root.glassLight ? "#ffffff" : root.surface, root.glassLight ? 0.74 : 0.30))
    readonly property color onTertiaryContainer: root.role("onTertiaryContainer", root.mix(root.cyan, root.glassLight ? "#000000" : "#ffffff", 0.50))

    // Full M3 surface/state role set (used by adapted controls from P2 on).
    readonly property color surfaceBright: root.role("surfaceBright", root.mix(root.surface, root.text, 0.30))
    readonly property color surfaceTint: root.role("surfaceTint", root.accent)
    readonly property color onBackground: root.role("onBackground", root.text)
    readonly property color onSurface: root.role("onSurface", root.text)
    readonly property color onSurfaceVariant: root.role("onSurfaceVariant", root.textSecondary)
    readonly property color inverseSurface: root.role("inverseSurface", root.mix(root.surface, root.text, 0.80))
    readonly property color inverseOnSurface: root.role("inverseOnSurface", root.surface)
    readonly property color inversePrimary: root.role("inversePrimary", root.mix(root.accent, root.text, 0.55))
    readonly property color onSecondary: root.role("onSecondary", root.mix(root.secondary, root.surface, 0.20))
    readonly property color onTertiary: root.role("onTertiary", root.mix(root.cyan, root.surface, 0.20))

    readonly property color primaryFixed: root.role("primaryFixed", root.mix(root.accent, "#ffffff", 0.30))
    readonly property color primaryFixedDim: root.role("primaryFixedDim", root.mix(root.accent, "#ffffff", 0.55))
    readonly property color onPrimaryFixed: root.role("onPrimaryFixed", root.accentText)
    readonly property color onPrimaryFixedVariant: root.role("onPrimaryFixedVariant", root.mix(root.accentText, root.accent, 0.5))
    readonly property color secondaryFixed: root.role("secondaryFixed", root.mix(root.secondary, "#ffffff", 0.30))
    readonly property color secondaryFixedDim: root.role("secondaryFixedDim", root.mix(root.secondary, "#ffffff", 0.55))
    readonly property color onSecondaryFixed: root.role("onSecondaryFixed", root.accentText)
    readonly property color onSecondaryFixedVariant: root.role("onSecondaryFixedVariant", root.mix(root.accentText, root.secondary, 0.5))
    readonly property color tertiaryFixed: root.role("tertiaryFixed", root.mix(root.cyan, "#ffffff", 0.30))
    readonly property color tertiaryFixedDim: root.role("tertiaryFixedDim", root.mix(root.cyan, "#ffffff", 0.55))
    readonly property color onTertiaryFixed: root.role("onTertiaryFixed", root.accentText)
    readonly property color onTertiaryFixedVariant: root.role("onTertiaryFixedVariant", root.mix(root.accentText, root.cyan, 0.5))

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

    function color(name, fallback) {
        return ThemeManager.color(name, fallback)
    }

    function role(name, fallback) {
        return ThemeManager.role(name, fallback)
    }
}