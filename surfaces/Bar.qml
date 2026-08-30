import QtQuick
import Quickshell

import "bar"

PanelWindow {
    id: root

    property real paddingX: 6
    property real paddingY: 5
    property real shapeSize: 24

    default property alias content: content.data

    anchors {
        top: true
    }

    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    implicitWidth: content.childrenRect.width + root.paddingX * 2
    implicitHeight: content.childrenRect.height + root.paddingY * 2

    margins {
        left: 4
        right:4
        top: 4
        bottom: 4
    }

    BarShape {
        id: background

        anchors.fill: parent
        size: root.shapeSize
    }

    Item {
        id: content

        anchors {
            fill: parent
            leftMargin: root.paddingX
            rightMargin: root.paddingX
            topMargin: root.paddingY
            bottomMargin: root.paddingY
        }
    }
}
