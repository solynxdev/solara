import QtQuick

import "../../services"
import "../../theme"

Rectangle {
    property real size: 12
    color: ConfigManager.get("notch.color", "#000000")

    radius: size
}