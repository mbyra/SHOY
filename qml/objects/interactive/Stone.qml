/*
 * This is a Stone object file. Player can push stone.
 * Stone is dynamic object, it means that it reacts to gravity.
 */
import VPlay 2.0
import QtQuick 2.0

EntityBaseDraggable {

    entityType: "Stone"

    colliderComponent: stoneCollider
    selectionMouseArea.anchors.fill: stoneCollider
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)

    Rectangle {
        id: rect
        width: gameScene.height/16
        height: width
        color: "grey"
        radius: width/2
    }

    CircleCollider {
        id:stoneCollider
        anchors.fill: rect
        density: 0.1
        radius:rect.width/2
        bodyType: Body.Dynamic
    }

}
