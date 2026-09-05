import QtQuick
import QtQuick.Shapes

import "../services"
import "../theme"

Item {
    id: root

    property real size: 12

    property color color: ConfigManager.get("notch.color", "#000000")

    width: size
    height: size

    Shape {
        anchors.fill: parent

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.color
            strokeWidth: 0

            PathMove {
                x: 0
                y: 0
            }

            PathLine {
                x: root.size
                y: 0
            }

            PathAngleArc {
                centerX: root.size
                centerY: root.size
                radiusX: root.size
                radiusY: root.size
                startAngle: -90
                sweepAngle: -90
                moveToStart: false
            }

            PathLine {
                x: 0
                y: root.size
            }

            PathLine {
                x: 0
                y: 0
            }
        }
    }
}
