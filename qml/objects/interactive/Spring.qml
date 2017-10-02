/*
 * This is a Spring object file. It is an object, which
 * allow player to jump higher than normal. Spirng has two states.
 */
import QtQuick 2.2
import VPlay 2.0
import "../hero"

EntityBaseDraggable {
    id: spring

    entityType: "Spring"
    state: "pressed"

    property real yOfNearestPlatform:0
    width: gameScene.width / 12 // visual width of the platform
    height: gameScene.height / 18 // visual height of the platform
    // set initialEntityPosition to a point outside the level

    //levelEditor properties
    colliderComponent: springCollider
    selectionMouseArea.anchors.fill: springCollider
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)

    // animations handling
    onStateChanged: {
        if (spring.state === "idle") {
            springAnimation.jumpTo(
                        "idle") // change the current animation to idle
            console.log(state )
        }
        if (spring.state === "pressed") {
            springAnimation.jumpTo(

                        "pressed"
                        ) // change the current animation to pressed
        }
    }



    //Spring image is different, when state of spring is different
    SpriteSequenceVPlay {
        id: springAnimation
        defaultSource: "qrc:/assets/pictures/SpringItem.png"
        width:parent.width
        height:parent.height*2
        anchors.bottom: parent.bottom

        SpriteVPlay {
            name: "pressed"
            frameWidth: 163
            frameHeight: 544
            frameY: 0
            frameX: 0
        }
        SpriteVPlay {
            name: "idle"
            frameWidth: 163
            frameHeight: 544
            frameDuration: 100
            frameY: 0
            frameX: 163
        }
    }
    onBeginContactWhileDragged: {
        var otherEntity = other.getBody().target
        if(otherEntity.entityType === "SolidPlatform" || otherEntity.entityType === "WoodenPlatform"){
            yOfNearestPlatform = otherEntity.y - height
            console.log(yOfNearestPlatform + " " + springCollider.active )
        }

    }

    onAllowedToBuildChanged: {if(allowedToBuild === false && yOfNearestPlatform !== 0) y = yOfNearestPlatform}
    // BoxCollider responsible for collision detection
    BoxCollider {
        id: springCollider

        anchors.centerIn: parent
        width: parent.width // actual width is the same as the parent entity
        height: parent.height // actual height is the same as the parent entity
        bodyType: Body.Static // only Dynamic bodies can collide with each other
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target

            if (otherEntity.entityType === "Hero" ){//&&
                 //   (hero.state ==="falling" || hero.state === "jumping")) {
                // Increase the number of active contacts the player has
                //hero.contacts++
                spring.state = "idle"
                //hero.jump(1) // the height of the jump is scaled by 1
                timer.running = true
                //hero.contacts--
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
