import QtQuick
import Quickshell
import Quickshell.Hyprland

import "notch"
import "wallpaper"
import "scheme"
import "../services"
import "../components"

PanelWindow {
    id: root

    signal settingsRequested()

    property string mode: "collapsed"
    property string displayedMode: "collapsed"

    property real animatedWidth: collapsedContent.implicitWidth
    property real animatedHeight: collapsedContent.implicitHeight

    readonly property real contentWidth: notchShape.width
    readonly property real contentHeight: notchShape.height

    readonly property bool collapsed: root.mode === "collapsed"
    readonly property bool expanded: root.mode === "expanded"
    readonly property bool launcherOpen: root.mode === "launcher"
    readonly property bool wallpaperOpen: root.mode === "wallpaper"
    readonly property bool schemeOpen: root.mode === "scheme"

    property real cornerSize:
        ConfigManager.get("notch.cornerSize", 24)

    property real contentPaddingX:
        ConfigManager.get("notch.contentPaddingX", 20)

    property real contentPaddingY:
        ConfigManager.get("notch.contentPaddingY", 5)

    property Item displayedContent: {
        switch (root.displayedMode) {
        case "collapsed":
            return collapsedContent
        case "expanded":
            return expandedContent
        case "launcher":
            return launcherContent
        case "wallpaper":
            return wallpaperContent
        case "scheme":
            return schemeContent
        default:
            return collapsedContent
        }
    }

    property real targetWidth: 0
    property real targetHeight: 0

    anchors {
        top: true
        left: true
        right: true
    }

    screen: root.screen

    focusable: mode === "launcher"

    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    implicitHeight: root.animatedHeight

    HyprlandFocusGrab {
        id: focusGrab

        windows: [root]

        active: root.mode === "launcher"
            || root.mode === "wallpaper"
            || root.mode === "scheme"
    }

    NotchShape {
        id: notchShape

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        width: root.animatedWidth
        height: root.animatedHeight

        size: root.cornerSize

        InvertedCorner {
            rotation: 90

            x: -size
            y: 0

            size: root.cornerSize
        }

        InvertedCorner {
            x: notchShape.width - 1
            y: 0

            size: root.cornerSize
        }
    }

    Item {
        id: hoverRegion

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        width: Math.max(
            collapsedContent.implicitWidth,
            expandedContent.implicitWidth
        ) + root.cornerSize * 2

        height: Math.max(
            collapsedContent.implicitHeight,
            expandedContent.implicitHeight
        ) + root.cornerSize

        HoverHandler {
            enabled: root.mode === "collapsed"
                  || root.mode === "expanded"

            onHoveredChanged: {
                if (root.mode !== "collapsed" &&
                    root.mode !== "expanded")
                    return

                if (hovered)
                    root.mode = "expanded"
                else
                    root.mode = "collapsed"
            }
        }
    }

    Item {
        id: activeContent

        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: root.displayedContent.implicitWidth
        implicitHeight: root.displayedContent.implicitHeight

        NotchCollapsed {
            id: collapsedContent

            screen: root.screen

            visible: root.displayedMode === "collapsed"
        }

        NotchExpanded {
            id: expandedContent

            visible: root.displayedMode === "expanded"
        }

        Launcher {
            id: launcherContent

            visible: root.displayedMode === "launcher"

            onClosed: {
                root.mode = "collapsed"
            }

            onCommandRequested: command => {
                if (command === "wallpaper") {
                    root.mode = "wallpaper"
                } else if (command === "scheme") {
                    root.mode = "scheme"
                } else if (command === "settings") {
                    root.mode = "collapsed"
                    root.settingsRequested()
                }
            }
        }

        Wallpaper {
            id: wallpaperContent

            visible: root.displayedMode === "wallpaper"

            onClosed: {
                root.mode = "collapsed"
            }
        }

        Scheme {
            id: schemeContent

            visible: root.displayedMode === "scheme"

            onClosed: {
                root.mode = "collapsed"
            }
        }
    }

    SequentialAnimation {
        id: transition

        property string nextMode: ""

        PropertyAction {
            target: root
            property: "displayedMode"
            value: transition.nextMode
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "animatedWidth"

                to: root.targetWidth

                duration: AnimationManager.notch.duration
                easing.type: AnimationManager.notch.easing
            }

            NumberAnimation {
                target: root
                property: "animatedHeight"

                to: root.targetHeight

                duration: AnimationManager.notch.duration
                easing.type: AnimationManager.notch.easing
            }
        }
    }

    onModeChanged: {
        if (root.mode === root.displayedMode)
            return

        const target = {
            "collapsed": collapsedContent,
            "expanded": expandedContent,
            "launcher": launcherContent,
            "wallpaper": wallpaperContent,
            "scheme": schemeContent
        }[root.mode]

        if (!target)
            return

        transition.stop()

        root.targetWidth = target.implicitWidth
        root.targetHeight = target.implicitHeight

        transition.nextMode = root.mode
        transition.start()
    }

    Component.onCompleted: {
        root.displayedMode = root.mode

        root.animatedWidth =
            collapsedContent.implicitWidth

        root.animatedHeight =
            collapsedContent.implicitHeight
    }
}
