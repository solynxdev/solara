import "../../theme"
import ".."
import QtQuick

Item {
    id: root

    property bool checked: false

    signal toggled(bool checked)

    width: 44
    height: 24
    opacity: hover.hovered ? 1 : 0.85

    Rectangle {
        id: track

        anchors.fill: parent
        radius: height / 2
        color: root.checked ? Theme.accent : Theme.surfaceContainerHighest

        Behavior on color {
            CAnim {}
        }

    }

    Rectangle {
        id: knob

        width: parent.height - 6
        height: parent.height - 6
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 3 : 3
        radius: width / 2
        color: root.checked ? Theme.accentText : Theme.text

        Behavior on x {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }

        }

    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        onTapped: {
            root.checked = !root.checked;
            root.toggled(root.checked);
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }

    }

}
