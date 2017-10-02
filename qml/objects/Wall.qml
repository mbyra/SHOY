/*
 * This is a Wall object file. It defines
 * a wall which is one the right and left side of the tower.
 * These two walls has one goal - to not allow the hero to leave the tower.
 * Wall has it's own collider which blocks the hero.
 * In future maybe there will be other object which will be hanged on the wall.
 */
import QtQuick 2.5
import VPlay 2.0
import "../scenes"

EntityBase{
    id: wall

    entityType: "Wall"
    width: gameScene.width/64 // visual width of the wall
    height:  gameScene.height*2 //twice time bigger than we can see to block the possibility to jump over the wall

    //Image of the wall
    Image {
        id: wallImg
        source: "qrc:/assets/pictures/brickwall_long@3x.png"
        anchors.fill: parent
    }

    // BoxCollider responsible for collision detection
    BoxCollider {
        id: wallCollider
        width: parent.width // actual width is the same as the parent entity
        height: parent.height // actual height is the same as the parent entity
        bodyType: Body.Static // only Dynamic bodies can collide with each other
        friction: 0     //This is because we don't want to let hero hang himself on the wall.
    }
}
