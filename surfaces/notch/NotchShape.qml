import QtQuick

import "../../theme"

Rectangle {
    property real size: 12
    color: Theme.chrome

    topLeftRadius: 0
    topRightRadius: 0
    bottomLeftRadius: size
    bottomRightRadius: size
}
