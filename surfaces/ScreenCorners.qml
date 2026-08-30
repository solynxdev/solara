import QtQuick
import Quickshell

import "../components"

PanelWindow {
    id: root

    property real cornerSize: 24

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        item: clickThroughArea
        intersection: Intersection.Xor
    }

    Item {
        id: clickThroughArea

        anchors.fill: parent
    }

    // Top-left
    InvertedCorner {
        anchors {
            top: parent.top
            left: parent.left
        }

        size: root.cornerSize
    }

    // Top-right
    InvertedCorner {
        anchors {
            top: parent.top
            right: parent.right
        }

        rotation: 90
        size: root.cornerSize
    }

    // Bottom-left
    InvertedCorner {
        anchors {
            bottom: parent.bottom
            left: parent.left
        }

        rotation: 270
        size: root.cornerSize
    }

    // Bottom-right
    InvertedCorner {
        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        rotation: 180
        size: root.cornerSize
    }
}
