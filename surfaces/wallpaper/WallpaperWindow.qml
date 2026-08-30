import QtQuick
import Quickshell
import Quickshell.Wayland

import "../../theme"

PanelWindow {
    id: root

    required property var targetScreen
    required property string wallpaperPath

    screen: targetScreen

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    focusable: false

    WlrLayershell.layer: WlrLayer.Bottom

    color: Theme.background

    Image {
        anchors.fill: parent

        source: root.wallpaperPath

        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
    }
}
