/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Derived from end-4/dots-hyprland services/MaterialThemeLoader.qml (GPL-3.0):
 * simplified to a pure role source — watches the matugen-generated colors
 * file, converts snake_case roles to camelCase, keeps the last valid palette
 * on malformed/missing output instead of failing.
 */

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../services"


Item {
    id: root

    readonly property string colorsPath:
        ConfigManager.get(
            "theme.colorsFile",
            Quickshell.env("HOME")
            + "/.local/state/quickshell/user/generated/colors.json"
        )

    property var roles: null
    property bool loaded: false
    property int revision: 0

    signal loadFailed()

    FileView {
        id: themeFileView

        // Path is assigned only after the generated file is known to exist
        // (attach()), so a cold start without colors.json does not warn.
        path: ""
        watchChanges: true

        onFileChanged: {
            themeFileView.reload()
            parseTimer.restart()
        }

        onLoadedChanged: {
            if (themeFileView.loaded)
                parseTimer.restart()
        }

        onLoadFailed: root.keepLast()
    }

    Timer {
        id: parseTimer

        interval: ConfigManager.get("theme.parseDelay", 100)
        repeat: false

        onTriggered: root.parse()
    }

    property bool warnedGeneration: false

    Timer {
        id: generationTimer

        interval: 250
        repeat: false

        onTriggered: root.generate()
    }

    Connections {
        target: ConfigManager

        function onConfigLoaded() {
            root.generate()
        }

        function onValueChanged(path) {
            if (path === "wallpaper") {
                generationTimer.restart()
            } else if (
                path === "scheme"
                && ConfigManager.get("scheme", "") === "dynamic"
            ) {
                generationTimer.restart()
            }
        }
    }

    Process {
        id: matugenProcess

        onExited: (exitCode, exitStatus) => {
            matugenProcess.running = false

            if (exitCode === 0) {
                root.warnedGeneration = false
                root.attach()
            } else {
                if (!root.warnedGeneration) {
                    root.warnedGeneration = true
                    console.warn(
                        "Solara: matugen generation failed; keeping last valid palette"
                    )
                }
            }
        }
    }

    readonly property string matugenConfig:
        Quickshell.env("HOME")
        + "/.config/solara/matugen/config.toml"

    function attach() {
        themeFileView.path = root.colorsPath
        themeFileView.reload()
        parseTimer.restart()
    }

    function generate() {
        if (ConfigManager.get("scheme", "") !== "dynamic")
            return

        const wallpaper = ConfigManager.get("wallpaper", "")

        if (wallpaper.length === 0 || matugenProcess.running)
            return

        matugenProcess.command = [
            "/usr/bin/matugen", "-c", root.matugenConfig,
            "image", "--source-color-index", "0",
            wallpaper,
        ]
        matugenProcess.running = true
    }

    function snakeToCamel(key) {
        return key.replace(/_([a-z])/g, (match, letter) => letter.toUpperCase())
    }

    function parse() {
        const content = themeFileView.text().trim()

        if (!content)
            return

        try {
            const json = JSON.parse(content)
            const converted = {}

            for (const key in json) {
                if (json.hasOwnProperty(key))
                    converted[snakeToCamel(key)] = json[key]
            }

            root.roles = converted
            root.loaded = true
            root.revision++
            root.rolesChanged()
        } catch (error) {
            root.keepLast()
            console.warn(
                "Solara: failed to parse generated colors:",
                error
            )
        }
    }

    function keepLast() {
        if (root.loaded) {
            root.revision++
            root.rolesChanged()
        } else {
            root.loadFailed()
        }
    }

    function reload() {
        themeFileView.reload()
    }

    Component.onCompleted: {
        root.generate()
    }
}