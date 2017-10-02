/*
 * This is a Bumper object file. It is an object, which
 * allow player to jump higher than normal. Spirng has two states.
 */
import QtQuick 2.2
import VPlay 2.0
import "../hero"

EntityBaseDraggable {
    id: bumper

    entityType: "Bumper"
    state: "pressed"

    property real yOfNearestPlatform:0
    width: gameScene.width / 12 // visual width of the platform
    height: gameScene.height / 16 // visual height of the platform
    // set initialEntityPosition to a point outside the level

    //levelEditor properties
    colliderComponent: bumperCollider
    selectionMouseArea.anchors.fill: bumperCollider
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)

    // animations handling
    onStateChanged: {
        if (bumper.state === "idle") {
            bumperAnimation.jumpTo(
                        "idle") // change the current animation to idle
            console.log(state )
        }
        if (bumper.state === "pressed") {
            bumperAnimation.jumpTo("pressed") // change the current animation to pressed
        }
    }

    //Bumper image is different, when state of bumper is different
    SpriteSequenceVPlay {
        id: bumperAnimation
        defaultSource: "qrc:/assets/pictures/BumperItem.png"
        width:parent.width
        height:parent.height
        anchors.bottom: parent.bottom

        SpriteVPlay {
            name: "pressed"
            frameWidth: 355
            frameHeight: 434
            frameY: 0
            frameX: 0
        }
        SpriteVPlay {
            name: "idle"
            frameWidth: 355
            frameHeight: 434
            frameDuration: 200
            frameY: 0
            frameX: 355
        }
    }
    onBeginContactWhileDragged: {
        var otherEntity = other.getBody().target
        if(otherEntity.entityType === "SolidPlatform" || otherEntity.entityType === "WoodenPlatform"){
            yOfNearestPlatform = otherEntity.y - height
            console.log(yOfNearestPlatform + " " + bumperCollider.active )
        }

    }

    onAllowedToBuildChanged: {if(allowedToBuild === false && yOfNearestPlatform !== 0) y = yOfNearestPlatform}
    // BoxCollider responsible for collision detection
    BoxCollider {
        id: bumperCollider

        anchors.centerIn: parent
        width: parent.width // actual width is the same as the parent entity
        height: parent.height // actual height is the same as the parent entity
        bodyType: Body.Static // only Dynamic bodies can collide with each other
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target

            if (otherEntity.entityType === "Hero" ){//&&
                bumper.state = "idle"
                timer.running = true
            }
        }
    }

    Timer{
        id: timer
        interval: 500
        onTriggered: parent.state = "pressed"
    }

    states: [
        State {
            name: "idle"
        },
        State {
            name: "pressed"
        }
    ]
}
