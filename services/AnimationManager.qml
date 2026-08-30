pragma Singleton

import QtQuick

Item {
    id: root

    property bool enabled: true
    property bool reducedMotion: false

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
        readonly property int enter: Easing.OutCubic
        readonly property int exit: Easing.InCubic
    }

    readonly property QtObject notch: QtObject {
        readonly property int duration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.normal

        readonly property int easing:
            root.easing.emphasized

        readonly property int contentDuration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.fast
    }

    readonly property QtObject content: QtObject {
        readonly property int enterDuration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.fast

        readonly property int exitDuration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.fast

        readonly property int enterEasing:
            root.easing.enter

        readonly property int exitEasing:
            root.easing.exit
    }

    readonly property QtObject wallpaper: QtObject {
        readonly property int duration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.slow

        readonly property int easing:
            root.easing.standard

        readonly property int style: 0

        readonly property real oldOpacity:
            style === 0 ? 1.0 : 1.0

        readonly property real newOpacity: 1.0
    }

    readonly property QtObject scheme: QtObject {
        readonly property int duration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.normal

        readonly property int easing:
            root.easing.standard

        readonly property int style: 0
    }

    readonly property QtObject interaction: QtObject {
        readonly property int hoverDuration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.fast

        readonly property int pressDuration:
            root.reducedMotion
                ? root.timings.instant
                : root.timings.fast

        readonly property int hoverEasing:
            root.easing.standard

        readonly property int pressEasing:
            root.easing.emphasized
    }
}
