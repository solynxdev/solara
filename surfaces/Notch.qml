import "../components"
import "../services"
import QtQuick
import Quickshell
import Quickshell.Hyprland
import "notch"
import "scheme"
import "wallpaper"

PanelWindow {
    id: root

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
    readonly property bool settingsOpen: root.mode === "settings"
    property real cornerSize: ConfigManager.get("notch.cornerSize", 24)
    property real contentPaddingX: ConfigManager.get("notch.contentPaddingX", 20)
    property real contentPaddingY: ConfigManager.get("notch.contentPaddingY", 5)
    property Item displayedContent: {
        switch (root.displayedMode) {
        case "collapsed":
            return collapsedContent;
        case "expanded":
            return expandedContent;
        case "launcher":
            return launcherContent;
        case "wallpaper":
            return wallpaperContent;
        case "scheme":
            return schemeContent;
        case "settings":
            return settingsContent;
        default:
            return collapsedContent;
        }
    }
    property real targetWidth: 0
    property real targetHeight: 0

    screen: root.screen
    focusable: root.mode === "launcher" || root.mode === "settings"
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitHeight: root.animatedHeight
    onModeChanged: {
        if (root.mode === root.displayedMode)
            return ;

        const target = {
            "collapsed": collapsedContent,
            "expanded": expandedContent,
            "launcher": launcherContent,
            "wallpaper": wallpaperContent,
            "scheme": schemeContent,
            "settings": settingsContent
        }[root.mode];
        if (!target)
            return ;

        transition.stop();
        root.targetWidth = target.implicitWidth;
        root.targetHeight = target.implicitHeight;
        transition.nextMode = root.mode;
        transition.start();
    }
    Component.onCompleted: {
        root.displayedMode = root.mode;
        root.animatedWidth = collapsedContent.implicitWidth;
        root.animatedHeight = collapsedContent.implicitHeight;
    }

    anchors {
        top: true
        left: true
        right: true
    }

    HyprlandFocusGrab {
        id: focusGrab

        windows: [root]
        active: root.mode === "launcher" || root.mode === "wallpaper" || root.mode === "scheme" || root.mode === "settings"
    }

    NotchShape {
        id: notchShape

        width: root.animatedWidth
        height: root.animatedHeight
        size: root.cornerSize

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

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

        width: Math.max(collapsedContent.implicitWidth, expandedContent.implicitWidth) + root.cornerSize * 2
        height: Math.max(collapsedContent.implicitHeight, expandedContent.implicitHeight) + root.cornerSize

        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        HoverHandler {
            enabled: root.mode === "collapsed" || root.mode === "expanded"
            onHoveredChanged: {
                if (root.mode !== "collapsed" && root.mode !== "expanded")
                    return ;

                if (hovered)
                    root.mode = "expanded";
                else
                    root.mode = "collapsed";
            }
        }

    }

    Item {
        id: activeContent

        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        implicitWidth: root.displayedContent.implicitWidth
        implicitHeight: root.displayedContent.implicitHeight

        NotchCollapsed {
            id: collapsedContent

            screen: root.screen
            opacity: root.displayedMode === "collapsed" ? 1 : 0
            scale: root.displayedMode === "collapsed" ? 1 : 0.96
            enabled: root.displayedMode === "collapsed"

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

        }

        NotchExpanded {
            id: expandedContent

            opacity: root.displayedMode === "expanded" ? 1 : 0
            scale: root.displayedMode === "expanded" ? 1 : 0.96
            enabled: root.displayedMode === "expanded"

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

        }

        Launcher {
            id: launcherContent

            opacity: root.displayedMode === "launcher" ? 1 : 0
            scale: root.displayedMode === "launcher" ? 1 : 0.96
            enabled: root.displayedMode === "launcher"
            onClosed: {
                root.mode = "collapsed";
            }
            onCommandRequested: (command) => {
                if (command === "wallpaper")
                    root.mode = "wallpaper";
                else if (command === "scheme")
                    root.mode = "scheme";
                else if (command === "settings")
                    root.mode = "settings";
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

        }

        Wallpaper {
            id: wallpaperContent

            opacity: root.displayedMode === "wallpaper" ? 1 : 0
            scale: root.displayedMode === "wallpaper" ? 1 : 0.96
            enabled: root.displayedMode === "wallpaper"
            onClosed: {
                root.mode = "collapsed";
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

        }

        Scheme {
            id: schemeContent

            opacity: root.displayedMode === "scheme" ? 1 : 0
            scale: root.displayedMode === "scheme" ? 1 : 0.96
            enabled: root.displayedMode === "scheme"
            onClosed: {
                root.mode = "collapsed";
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

        }

        Settings {
            id: settingsContent

            opacity: root.displayedMode === "settings" ? 1 : 0
            scale: root.displayedMode === "settings" ? 1 : 0.96
            enabled: root.displayedMode === "settings"
            onClosed: {
                root.mode = "collapsed";
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }

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

}
