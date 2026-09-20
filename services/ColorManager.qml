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

        path: root.colorsPath
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
        themeFileView.reload()
    }
}