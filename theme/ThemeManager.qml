/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Scheme loading adapted from end-4/dots-hyprland services/MaterialThemeLoader.qml
 * (GPL-3.0): replaced Process+cat with a watched FileView, added light/dark
 * mode resolution (theme.mode) and the matugen ColorManager handoff for the
 * "dynamic" scheme so static and dynamic schemes converge on one role set.
 */

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../services"


Item {
    id: root

    property string currentName: ""
    property var current: null
    property string resolvedMode: ""
    property var roles: null
    property var flat: ({})

    property int revision: 0

    readonly property bool loaded:
        root.current !== null || ColorManager.loaded

    signal schemeChanged(string name)
    signal modeChanged(string mode)

    FileView {
        id: schemeView

        property string fileName: ""

        path: Quickshell.env("HOME")
            + "/.config/solara/schemes/"
            + schemeView.fileName
            + ".json"

        watchChanges: true

        onFileChanged: {
            if (root.currentName !== schemeView.fileName)
                return

            schemeView.reload()
            parseTimer.restart()
        }

        onLoadedChanged: {
            if (
                schemeView.loaded
                && root.currentName === schemeView.fileName
            ) {
                parseTimer.restart()
            }
        }

        onLoadFailed: {
            console.warn(
                "Solara: failed to load scheme:",
                schemeView.fileName
            )
        }
    }

    Timer {
        id: parseTimer

        interval: 50
        repeat: false

        onTriggered: root.parseStatic()
    }

    Connections {
        target: ConfigManager

        function onConfigLoaded() {
            root.loadScheme(
                ConfigManager.get("scheme", "catppuccin/mocha")
            )
        }

        function onValueChanged(path) {
            if (path === "scheme") {
                root.loadScheme(
                    ConfigManager.get("scheme", "catppuccin/mocha")
                )
            } else if (path === "theme.mode") {
                root.reapply()
            }
        }
    }

    Connections {
        target: ColorManager

        function onRolesChanged() {
            if (root.currentName === "dynamic")
                root.reapply()
        }
    }

    function requestedMode() {
        const mode = ConfigManager.get("theme.mode", "auto")

        return (mode === "light" || mode === "dark") ? mode : "auto"
    }

    function hexLightness(hex) {
        if (!hex || typeof hex !== "string")
            return 0.5

        const value = hex.replace("#", "")

        if (value.length !== 6)
            return 0.5

        const r = parseInt(value.slice(0, 2), 16) / 255
        const g = parseInt(value.slice(2, 4), 16) / 255
        const b = parseInt(value.slice(4, 6), 16) / 255
        const max = Math.max(r, g, b)
        const min = Math.min(r, g, b)

        return (max + min) / 2
    }

    function resolveMode() {
        if (root.currentName === "dynamic") {
            const override = root.requestedMode()

            if (override !== "auto")
                return override

            if (ColorManager.roles && ColorManager.roles.background)
                return root.hexLightness(ColorManager.roles.background) < 0.5
                    ? "dark"
                    : "light"

            return "dark"
        }

        const scheme = root.current

        if (!scheme)
            return "dark"

        const override = root.requestedMode()

        if (override !== "auto")
            return override

        const native = scheme.mode === "light" ? "light" : "dark"

        if (scheme[native])
            return native

        return scheme.light ? "light" : "dark"
    }

    function reapply() {
        const mode = root.resolveMode()

        if (root.currentName === "dynamic") {
            const changedMode = root.resolvedMode !== mode

            root.resolvedMode = mode
            root.current = null
            root.roles = ColorManager.roles
            root.flat = root.roles || {}

            root.revision++

            if (changedMode && mode.length > 0)
                root.modeChanged(mode)

            return
        }

        const scheme = root.current

        if (!scheme)
            return

        let resolved = mode
        const native = scheme.mode === "light" ? "light" : "dark"

        if (!scheme[resolved])
            resolved = scheme[native] ? native : (scheme.light ? "light" : "dark")

        const changedMode = root.resolvedMode !== resolved
        const block = scheme[resolved]

        root.resolvedMode = resolved
        root.roles = (block && block.roles) ? block.roles : null
        root.flat = (block && block.colors) ? block.colors : {}

        root.revision++

        if (changedMode && resolved.length > 0)
            root.modeChanged(resolved)
    }

    function parseStatic() {
        const text = schemeView.text().trim()

        if (!text)
            return

        try {
            const scheme = JSON.parse(text)

            if (root.currentName !== schemeView.fileName)
                return

            root.current = scheme
            root.reapply()
        } catch (error) {
            console.warn(
                "Solara: failed to parse scheme:",
                schemeView.fileName,
                error
            )
        }
    }

    function loadScheme(name) {
        if (!name || name.length === 0)
            return

        if (name === root.currentName && root.current !== null) {
            root.reapply()
            return
        }

        root.currentName = name
        root.current = null
        root.schemeChanged(name)

        if (name === "dynamic") {
            root.reapply()
            return
        }

        schemeView.fileName = name
        schemeView.reload()
    }

    function setScheme(name) {
        if (!name || name.length === 0)
            return

        ConfigManager.set("scheme", name)
    }

    function setMode(mode) {
        if (mode !== "light" && mode !== "dark" && mode !== "auto")
            return

        ConfigManager.set("theme.mode", mode)
    }

    function color(name, fallback = "transparent") {
        const currentRevision = root.revision

        if (root.flat && root.flat[name] !== undefined)
            return root.flat[name]

        if (root.roles && root.roles[name] !== undefined)
            return root.roles[name]

        return fallback
    }

    function role(name, fallback = "transparent") {
        const currentRevision = root.revision

        if (root.roles && root.roles[name] !== undefined)
            return root.roles[name]

        return fallback
    }

    Component.onCompleted: {
        if (ConfigManager.loaded) {
            root.loadScheme(
                ConfigManager.get("scheme", "catppuccin/mocha")
            )
        }
    }
}