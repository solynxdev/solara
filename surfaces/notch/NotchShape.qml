import QtQuick

import "../../services"
import "../../theme"

Rectangle {
    property real size: 12
    color: ConfigManager.get("notch.color", "#000000")

    topLeftRadius: 0
    topRightRadius: 0
    bottomLeftRadius: size
    bottomRightRadius: size
}