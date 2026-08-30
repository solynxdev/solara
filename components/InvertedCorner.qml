import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real size: 12

    width: size
    height: size

    Shape {
        anchors.fill: parent

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: "black"
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
