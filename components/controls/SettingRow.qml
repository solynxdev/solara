import "../../theme"
import QtQuick

Item {
    id: root

    property string label: ""
    property string hint: ""
    property string valueText: ""
    property Item control: null

    width: parent ? parent.width : 320
    height: 46
    onControlChanged: {
        if (!root.control)
            return ;

        root.control.anchors.right = rowBackground.right;
        root.control.anchors.rightMargin = 12;
        root.control.anchors.verticalCenter = rowBackground.verticalCenter;
    }

    Rectangle {
        id: rowBackground

        anchors.fill: parent
        radius: 14
        color: "transparent"
        border.width: 0
        border.color: "transparent"
    }

    Column {
        id: textColumn

        spacing: 2

        anchors {
            left: parent.left
            leftMargin: 14
            verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.label
            color: Theme.text

            font {
                family: Theme.fontFamily
                pixelSize: 13
            }

        }

        Text {
            visible: root.hint.length > 0
            text: root.hint
            color: Theme.textSecondary

            font {
                family: Theme.fontFamily
                pixelSize: 10
            }

        }

    }

    Text {
        visible: root.valueText.length > 0 && !root.control
        text: root.valueText
        color: Theme.textSecondary

        anchors {
            right: parent.right
            rightMargin: 14
            verticalCenter: parent.verticalCenter
        }

        font {
            family: Theme.fontFamily
            pixelSize: 11
        }

    }

}
