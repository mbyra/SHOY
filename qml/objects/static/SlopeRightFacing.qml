/*
 * This is a Slope object file. It is an obstacle, which
 * makes it harder for player to move upward, because it is sliding down.
 */
import QtQuick 2.2
import VPlay 2.0
import "../hero"
EntityBaseDraggable {
    id: slope

    entityType: "SlopeRight"

    property real yOfNearestPlatform:0
    //levelEditor properties
    colliderComponent: slopeCollider
    selectionMouseArea.anchors.fill: image
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    onBeginContactWhileDragged: {
        var otherEntity = other.getBody().target
        if(otherEntity.entityType === "SolidPlatform" || otherEntity.entityType === "WoodenPlatform"){
            yOfNearestPlatform = otherEntity.y - height - 1
            console.log(yOfNearestPlatform )
        }

    }

    onAllowedToBuildChanged: {if(allowedToBuild === false && yOfNearestPlatform !== 0) y = yOfNearestPlatform}
    dragOffset: Qt.point(-width/2,-70)
    width: gameScene.width/5              // visual width of the slope
    height: window.baseSceneHeight/5   // visual height of the slope


    Image{
        id:image
        source:"qrc:/assets/pictures/slope_orange.png"
        anchors.fill: parent
    }

    // PolygonCollider responsible for collision detection
    PolygonCollider {
        id: slopeCollider

    //Defining the shape of the collider
        vertices: [
            Qt.point(x,y),
            Qt.point(x,y+height),
            Qt.point(x+width,y + height)
        ]

        width: parent.width // actual width is the same as the parent entity
        height: parent.height // actual height is the same as the parent entity
        bodyType: Body.Static // only Dynamic bodies can collide with each other
        friction: 0
    }
}
