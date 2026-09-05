pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string configPath:
        Quickshell.env("HOME") + "/.config/solara/config.json"

    readonly property string defaultConfigPath:
        Quickshell.env("HOME")
        + "/.config/solara/config/default-config.json"

    property var store: ({})
    property var defaults: ({})

    property bool loaded: false
    property bool writing: false

    property int revision: 0

    signal configLoaded()
    signal configChanged()
    signal valueChanged(string path)

    Process {
        id: defaultReader

        command: [
            "cat",
            root.defaultConfigPath
        ]

        stdout: StdioCollector {
            id: defaultOutput
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.warn(
                    "Solara: failed to read default-config.json"
                )

                root.defaults = {}
            } else {
                const text = defaultOutput.text.trim()

                if (!text) {
                    root.defaults = {}
                } else {
                    try {
                        root.defaults = JSON.parse(text)
                    } catch (error) {
                        console.warn(
                            "Solara: failed to parse default-config.json:",
                            error
                        )

                        root.defaults = {}
                    }
                }
            }

            configReader.running = false
            configReader.running = true
        }
    }

    Process {
        id: configReader

        command: [
            "cat",
            root.configPath
        ]

        stdout: StdioCollector {
            id: configOutput
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                root.store = {}
            } else {
                const text = configOutput.text.trim()

                if (!text) {
                    root.store = {}
                } else {
                    try {
                        root.store = JSON.parse(text)
                    } catch (error) {
                        console.warn(
                            "Solara: failed to parse config.json:",
                            error
                        )

                        root.store = {}
                    }
                }
            }

            root.loaded = true
            root.revision++

            root.configLoaded()
            root.configChanged()
        }
    }

    Process {
        id: writer

        property string content: ""

        command: [
            "sh",
            "-c",
            "mkdir -p \"$(dirname \"$1\")\" && "
            + "printf '%s\\n' \"$2\" > \"$1\"",
            "solara-config",
            root.configPath,
            writer.content
        ]

        onRunningChanged: {
            if (!running)
                root.writing = false
        }
    }

    FileView {
        id: configWatcher

        path: root.configPath

        watchChanges: true

        onFileChanged: {
            if (root.writing)
                return

            reloadTimer.restart()
        }
    }

    Timer {
        id: reloadTimer

        interval: 100
        repeat: false

        onTriggered: {
            root.load()
        }
    }

    function clone(object) {
        if (!object || typeof object !== "object")
            return object

        return JSON.parse(JSON.stringify(object))
    }

    function merge(base, override) {
        const result = clone(base || {})

        if (
            !override ||
            typeof override !== "object" ||
            Array.isArray(override)
        ) {
            return result
        }

        for (const key in override) {
            const value = override[key]

            if (
                value !== null &&
                typeof value === "object" &&
                !Array.isArray(value) &&
                result[key] !== null &&
                typeof result[key] === "object" &&
                !Array.isArray(result[key])
            ) {
                result[key] = merge(result[key], value)
            } else {
                result[key] = value
            }
        }

        return result
    }

    function effectiveConfig() {
        // Explicitly touch revision so QML bindings that call
        // ConfigManager.get() are invalidated after a change.
        const currentRevision = root.revision

        if (root.store.useDefaultConfig)
            return merge(root.defaults, root.store)

        return clone(root.store)
    }

    function get(path, fallback = null) {
        const source = effectiveConfig()

        const value = getPath(source, path)

        if (value === undefined)
            return fallback

        return value
    }

    function set(path, value) {
        if (!path)
            return

        const updated = clone(root.store)

        setPath(updated, path, value)

        root.store = updated

        root.revision++

        root.configChanged()
        root.valueChanged(path)

        save()
    }

    function remove(path) {
        if (!path)
            return

        const updated = clone(root.store)

        removePath(updated, path)

        root.store = updated

        root.revision++

        root.configChanged()
        root.valueChanged(path)

        save()
    }

    function has(path) {
        return getPath(
            effectiveConfig(),
            path
        ) !== undefined
    }

    function getPath(object, path) {
        if (!object || !path)
            return undefined

        const parts = path.split(".")
        let current = object

        for (const part of parts) {
            if (
                current === null ||
                current === undefined ||
                typeof current !== "object" ||
                current[part] === undefined
            ) {
                return undefined
            }

            current = current[part]
        }

        return current
    }

    function setPath(object, path, value) {
        const parts = path.split(".")
        let current = object

        for (let i = 0; i < parts.length - 1; ++i) {
            const part = parts[i]

            if (
                current[part] === undefined ||
                current[part] === null ||
                typeof current[part] !== "object" ||
                Array.isArray(current[part])
            ) {
                current[part] = {}
            }

            current = current[part]
        }

        current[parts[parts.length - 1]] = value
    }

    function removePath(object, path) {
        const parts = path.split(".")

        if (parts.length === 0)
            return

        let current = object

        for (let i = 0; i < parts.length - 1; ++i) {
            if (
                current[parts[i]] === undefined ||
                current[parts[i]] === null ||
                typeof current[parts[i]] !== "object"
            ) {
                return
            }

            current = current[parts[i]]
        }

        delete current[parts[parts.length - 1]]
    }

    function load() {
        root.loaded = false

        defaultReader.running = false
        defaultReader.running = true
    }

    function save() {
        root.writing = true

        writer.content = JSON.stringify(
            root.store,
            null,
            4
        )

        writer.running = false
        writer.running = true
    }

    function reset() {
        root.store = {}

        root.revision++

        root.configChanged()

        save()
    }

    Component.onCompleted: {
        load()
    }
}
