import "../../theme"
import QtQuick

Item {
    id: root

    property var options: []
    property int index: 0
    readonly property int optionCount: Math.max(root.options.length, 0)
    readonly property real segmentWidth: root.width / Math.max(optionCount, 1)
    readonly property real knobX: segmentWidth * root.index

    signal changed(int index)

    width: 180
    height: 28

    Rectangle {
        id: background

        anchors.fill: parent
        radius: height / 2
        color: Theme.surfaceContainerHighest
    }

    Rectangle {
        id: knob

        width: root.segmentWidth
        height: root.height - 4

        x: root.knobX + 2
        radius: height / 2
        color: Theme.accent

        anchors {
            verticalCenter: parent.verticalCenter
        }

        Behavior on x {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }

        }

    }

    Repeater {
        model: root.options

        delegate: ButtonBase {
            required property int index
            required property var modelData

            x: index * root.segmentWidth
            y: 0

            implicitWidth: root.segmentWidth
            implicitHeight: root.height

            type: ButtonBase.Text
            radiusMorph: false
            radius: height / 2

            onClicked: {
                root.index = index
                root.changed(index)
            }

            Text {
                anchors.centerIn: parent
                text: modelData

                color: index === root.index ? Theme.accentText : Theme.onSurfaceVariant

                font {
                    family: Theme.fontFamily
                    pointSize: 9
                    bold: index === root.index
                }

            }

        }

    }

}