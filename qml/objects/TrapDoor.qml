/*
This is TrapDoor game object. It's an obstacle, which main goal is to catch hero.
When it catches hero, hero cannot move and the game ends.
Trap door has two states - opened or closed. There can be multiplet trap doors, they lay on platforms.
*/

import QtQuick 2.0
import VPlay 2.0

EntityBaseDraggable{
    id: trapDoor
    entityType: "TrapDoor"

    property real yOfNearestPlatform:0
    //levelEditor properties
    colliderComponent: trapDoorCollider
    selectionMouseArea.anchors.fill: trapHole
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)
    onBeginContactWhileDragged: {
        var otherEntity = other.getBody().target
        if(otherEntity.entityType === "SolidPlatform" || otherEntity.entityType === "WoodenPlatform"){
            yOfNearestPlatform = otherEntity.y - height
            console.log(yOfNearestPlatform )
        }

    }

    onAllowedToBuildChanged: {if(allowedToBuild === false && yOfNearestPlatform !== 0) y = yOfNearestPlatform}

    state: "Open"
    //This property tells us if trap door is open. If it is, hero can be trapped.
    property bool isOpen
    property bool isHeroIn:false

    //this function is for turning on animation of closing the TrapDoor
    function closeTrapDoor()
    {
        firstBeamClose.restart()
        secondBeamClose.restart()
    }

    //this function is for turning on animation of opening the TrapDoor
    function openTrapDoor()
    {
        firstBeamOpen.restart()
        secondBeamOpen.restart()
    }

    //When object state change to open or close, we turn on closing or opening animation
    onStateChanged: {
        if(state === "Open")
            openTrapDoor()

        if(state === "Closed temporary")
            closeTrapDoor()
    }

    //size of the Trapdoor
    width: gameScene.height/15
    height: width

    //Our door
    Image{
        id: trapHole
        anchors.fill: parent
        source: "qrc:/assets/pictures/TrapDoor.png"
    }

    //Upper beam which can close or open. It's just for animation
    Image{
        id: firstBeam
        width: parent.width //We want from beam to be width as doors
        height: 20
        x: - width  //because x = 0 is at the beggining from the door
        //This set the y of this beam
        anchors.top: parent.top
        anchors.topMargin: parent.height / 4
        source: "qrc:/assets/pictures/beamForTrapDoor.png"

        //closing animation. In this animation we set player state to dead if he is inside when closing.
        PropertyAnimation on x{
            id: firstBeamClose
            from: - width
            to: 0
            duration: 500
            running: false
            onStarted: trapDoor.isOpen = false
            onStopped: {

                if(isHeroIn === true)
                    trapDoor.state = "Closed with player"

                else
                    trapDoor.state = "Closed temporary"
            }
        }

        //opening animation
        PropertyAnimation on x{
            id: firstBeamOpen
            from: 0
            to: -width
            duration: 500
            running: false
        }
    }


    //Lower beam which can close or open. It's just for animation
    Image{
        id: secondBeam
        width: parent.width //We want from beam to be width as doors
        height: 20
        x: - width //because x = 0 is at the beggining from the door
        //This set the y of this beam
        anchors.top: parent.top
        anchors.topMargin: (parent.height/3) * 2
        source: "qrc:/assets/pictures/beamForTrapDoor.png"

        //closing animation
        PropertyAnimation on x{
            id: secondBeamClose
            from: - width
            to: 0
            duration: 500
            running: false
        }

        //opening animation
        PropertyAnimation on x{
            id: secondBeamOpen
            from: 0
            to: -width
            duration: 500
            running: false
        }
    }

    //This boxCollider is to detect if player is inside
    BoxCollider{
        id: trapDoorCollider
        anchors.fill: parent
        bodyType: Body.Static
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target

            if (otherEntity.entityType === "Hero")
            {
                var point = mapFromItem(parent, parent.x, parent.y) // we get global x and y of the trapdoor
                //If hero is inside our TrapDoor, and state of trapDoor is open, catch him!
                if(otherEntity.x >= point.x - 10
                        && otherEntity.y >= point.y - 10
                        && otherEntity.x + otherEntity.width <= point.x + width + 10
                        && otherEntity.y + otherEntity.height <= point.y + height + 10
                        && trapDoor.state === "Open")
                {
                    otherEntity.collidersActive = false //we stop the player
                    isHeroIn = true //this is for end the game
                    closeTrapDoor() //starting animation of closing
                }
            }
        }
    }

    //this connection is for reset trapDoor. We want it open when new game start.
    Connections{
        target: window
        onStateChanged:{
            if(window.state === "game")
                trapDoor.state = "Open"
        }
    }

    //Here we declare states of trapDoor
    states: [

        State {
            //This state is when the door is open.
            name: "Open"
            PropertyChanges {target: trapDoor; isOpen: true }
        },

        State {
            //This state is when the door is closed without hero inside.
            name: "Closed temporary"
            PropertyChanges {target: trapDoor; isOpen:false }
        },

        State{
            //this state is when the door is closed with hero inside. Hero dies.
            name: "Closed with player"
            PropertyChanges { target: trapDoor; isOpen:false }
            //PropertyChanges { target: hero; state:"dead" }
        }
    ]
}
