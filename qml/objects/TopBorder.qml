
/*
 * This is definition of the TopBorder object.
 * TopBorder is special rectangle on the top
 * of the screen which is invisible for the
 * player, and which hero can not pass by
 * (can't be higher than top of board).
 * Border has its special box collider which
 * interact with the hero.
 *
 * When hero collides with object of type TopBorder,
 * he completes current level.
 */
import QtQuick 2.0
import VPlay 2.0

EntityBase {
    // EntityType name
    entityType: "TopBorder"

    // Border box collider
    BoxCollider {
        width: gameScene.width * 5 // use large width to make sure the hero can't fly past it
        height: gameScene.height/32
        bodyType: Body.Static // this body must not move

        collisionTestingOnlyMode: true

        // a Rectangle to visualize the border
        Rectangle {
            anchors.fill: parent
            color: "red"
            visible: false // set to false to hide
        }
    }
}
