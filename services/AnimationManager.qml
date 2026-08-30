pragma Singleton

import QtQuick

import "../services"

Item {
    id: root

    property bool enabled: true
    property bool reducedMotion: false

    property int notchDuration: 250

    readonly property QtObject timings: QtObject {
        readonly property int instant: 0
        readonly property int fast: 120
        readonly property int normal: 250
        readonly property int slow: 350
        readonly property int verySlow: 500
    }

    readonly property QtObject easing: QtObject {
        readonly property int standard: Easing.OutCubic
        readonly property int emphasized: Easing.OutQuart
    }

    readonly property QtObject notch: QtObject {
        readonly property int duration:
            root.reducedMotion
                ? root.timings.instant
                : root.notchDuration

        readonly property int easing:
            root.easing.emphasized
    }

    function sync() {
        root.enabled = ConfigManager.get("animations.enabled", true)
        root.reducedMotion = !root.enabled
        root.notchDuration = ConfigManager.get(
            "animations.notch.duration",
            250
        )
    }

    Connections {
        target: ConfigManager

        function onConfigLoaded() {
            root.sync()
        }

        function onValueChanged(path) {
            if (
                path === "animations.enabled" ||
                path === "animations.notch.duration"
            ) {
                root.sync()
            }
        }
    }

    Component.onCompleted: {
        root.sync()
    }
}