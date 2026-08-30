pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../services"

Item {
    id: root

    property string currentName: "catppuccin/mocha"
    property var current: null

    readonly property bool loaded: current !== null

    Process {
        id: reader

        property string schemeName: ""

        command: [
            "cat",
            Quickshell.env("HOME")
                + "/.config/solara/schemes/"
                + reader.schemeName
                + ".json"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()

                if (!text)
                    return

                try {
                    const scheme = JSON.parse(text)

                    if (reader.schemeName === root.currentName)
                        root.current = scheme

                } catch (error) {
                    console.warn(
                        "Solara: failed to parse scheme:",
                        reader.schemeName,
                        error
                    )
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.warn(
                    "Solara: failed to load scheme:",
                    reader.schemeName
                )
            }
        }
    }

    function loadScheme(name) {
        if (!name || name.length === 0)
            return

        root.currentName = name
        root.current = null

        if (name === "dynamic") {
            // Dynamic scheme will be implemented later.
            return
        }

        reader.schemeName = name
        reader.running = false
        reader.running = true
    }

    function setScheme(name) {
        if (!name || name.length === 0)
            return

        root.loadScheme(name)

        ConfigManager.set(
            "scheme",
            name
        )
    }

    function color(name, fallback = "transparent") {
        if (!root.current || !root.current.colors)
            return fallback

        return root.current.colors[name] ?? fallback
    }

    Connections {
        target: ConfigManager

        function onConfigLoaded() {
            root.loadScheme(
                ConfigManager.get(
                    "scheme",
                    "catppuccin/mocha"
                )
            )
        }
    }

    Component.onCompleted: {
        if (ConfigManager.loaded) {
            root.loadScheme(
                ConfigManager.get(
                    "scheme",
                    "catppuccin/mocha"
                )
            )
        }
    }
}
