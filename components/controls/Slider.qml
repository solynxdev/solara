import "../../theme"
import QtQuick

Item {
    id: root

    property real from: 0
    property real to: 100
    property real stepSize: 1
    property real value: 0
    property bool dragging: false
    readonly property real range: Math.max(root.to - root.from, 0.001)
    readonly property real ratio: (root.value - root.from) / root.range

    signal editingFinished()

    function applyAt(x) {
        const ratio = Math.max(0, Math.min(1, x / root.width));
        let raw = root.from + ratio * root.range;
        if (root.stepSize > 0)
            raw = Math.round(raw / root.stepSize) * root.stepSize;

        root.value = Math.max(root.from, Math.min(root.to, raw));
    }

    height: 26

    Rectangle {
        id: track

        height: 6
        radius: height / 2
        color: Theme.surfaceVariant

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: fill

            width: parent.width * root.ratio
            height: parent.height
            radius: height / 2
            color: Theme.accent

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

        }

    }

    Rectangle {
        id: knob

        width: 18
        height: 18
        x: track.x + track.width * root.ratio - width / 2
        y: parent.height / 2 - height / 2
        radius: width / 2
        color: root.dragging ? Theme.accent : (hover.hovered ? Theme.text : Theme.chrome)

        border {
            width: 2
            color: Theme.accent
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }

        }

    }

    HoverHandler {
        id: hover
    }

    MouseArea {
        id: area

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed: {
            root.dragging = true;
            root.applyAt(mouse.x);
        }
        onPositionChanged: {
            if (root.dragging)
                root.applyAt(mouse.x);

        }
        onReleased: {
            root.dragging = false;
            root.editingFinished();
        }
    }

}
