import QtQuick
import Quickshell

Text {
    id: clock

    property string timeFormat: "hh:mm:ss"

    color: "white"
    font.family: "Sans"
    font.pixelSize: 16
    font.weight: Font.Normal

    bottomPadding: 4

    y: 2

    text: Qt.formatDateTime(clockTime.date, timeFormat)

    SystemClock {
        id: clockTime
        precision: SystemClock.Seconds
    }
}
