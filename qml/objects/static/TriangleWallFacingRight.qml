/* This a triangle wall object. It is very hard to climb on it with circle, but easy with triangle.
 * There are two types of triangle walls
 */
import VPlay 2.0
import QtQuick 2.0

EntityBaseDraggable {
        id:triangleWall
        entityType: "TriangleWall"
        //levelEditor properties
        selectionMouseArea.anchors.fill: triangleWall
        inLevelEditingMode: window.state === "levelEditor"
        // if the obstacle was pressed and held, remove it
        onEntityPressAndHold: removeEntity()
        // since our levels have no size limit, we don't want any
        // boundaries when dragging our entities
        ignoreBounds: true
        width:height/2
        height: gameScene.height/10

// Images of the wall, it could have been done with Repeater
        Image {
            x:0
            y:parent.height/4
            width: parent.width
            height: parent.height/4
            source: "qrc:/assets/pictures/shape_14@3x.png"
        }

        Image {
            x:0
            y:0
            width: parent.width
            height: parent.height/4
            source: "qrc:/assets/pictures/shape_14@3x.png"
            rotation: 180
            mirror: true
        }
        Image {
            x:0
            y:parent.height/2
            width: parent.width
            height: parent.height/4
            source: "qrc:/assets/pictures/shape_14@3x.png"
            rotation: 180
            mirror: true
        }
        Image {
            x:0
            y:parent.height*3/4
            width: parent.width
            height: parent.height/4
            source: "qrc:/assets/pictures/shape_14@3x.png"
        }

// colliders of the wall, it could have been done with Repeater
        PolygonCollider{
            vertices: [Qt.point(0,0),Qt.point(0,parent.height/4),
            Qt.point(parent.width,0)]
            friction: 0.1
            bodyType: Body.Static

        }
        PolygonCollider{
            vertices: [Qt.point(0,parent.height/4),Qt.point(0,parent.height/2),
            Qt.point(parent.width,parent.height/2)]
            friction: 0.1
            bodyType: Body.Static

        }

            PolygonCollider{
                vertices: [Qt.point(0,parent.height/2),Qt.point(0,parent.height*3/4),
                Qt.point(parent.width,parent.height/2)]
                friction: 0.1
                bodyType: Body.Static

            }
            PolygonCollider{
                vertices: [Qt.point(0,parent.height*3/4),Qt.point(0,parent.height),
                Qt.point(parent.width,parent.height)]
                friction: 0.1
                bodyType: Body.Static

            }
}
