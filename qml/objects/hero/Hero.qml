/*
 * This is definition of the hero object.
 * This object inherits from herobase all properties, functions etc.
 * Here we just declare image and colliders.
 * That object we create in gameScene.
 * Every collider is set to be not active and every image is not visible - function from HeroBase turn them on when it's need.
 */

import QtQuick 2.0
import VPlay 2.0

HeroBase {
    id: hero // the id we use as a reference inside this class

    // Use this from GameScene to pause animation of shoy energy
    function pauseAnimation() {
        shoyEnergyCircle.pause()
        shoyEnergySquare.pause()
        shoyEnergyTriangle.pause()
    }
    // Use this from GameScene to resume animation of shoy energy
    function resumeAnimation() {
        shoyEnergyCircle.resume()
        shoyEnergySquare.resume()
        shoyEnergyTriangle.resume()
    }

    function resetHero(){
        resetHeroBase()
    }

    function contactActionStart(other){
                   var otherEntity = other.getBody().target
                   var otherEntityType = otherEntity.entityType
                   if(otherEntityType === "WoodenPlatform" || otherEntityType === "SlopeLeft"
                           || otherEntityType === "SlopeRight" || otherEntityType === "SolidPlatform"
                           ||  otherEntityType === "SolidPlatformVaryingSize"
                           || otherEntityType === "MovableShelf"
                           || otherEntityType === "VictoryPlatform"
                           || otherEntityType === "TriangleWall")

                       contacts++
                   else if (otherEntity.entityType === "Labirynth") {
                       gameScene.mouseArea.doubleClicked.disconnect(hero.jump)
                       gameScene.mouseArea.doubleClicked.connect(hero.inverseGravity)
                   }
                   if(otherEntityType === "VictoryPlatform" &&
                           hero.y + hero.height*0.9 > otherEntity.y)
                       hero.win()
    }
    function contactActionEnded(other){
                   var otherEntity = other.getBody().target
                   var otherEntityType = otherEntity.entityType
                   if(otherEntityType === "WoodenPlatform" || otherEntityType === "SlopeLeft"
                           || otherEntityType === "SlopeRight" || otherEntityType === "SolidPlatform"
                           ||  otherEntityType === "SolidPlatformVaryingSize"
                           || otherEntityType === "MovableShelf"
                           || otherEntityType === "VictoryPlatform"
                           || otherEntityType === "TriangleWall")
                   {
                       if(contacts > 0)
                            contacts--
                   }
                   if (otherEntity.entityType === "Labirynth") {
                       // If the player leaves labirynth he can again jump and cant reverse gravity
                       gameScene.mouseArea.doubleClicked.disconnect(inverseGravity)
                       gameScene.mouseArea.doubleClicked.connect(hero.jump)
                       gameScene.physicsWorld.gravity.y = 36
                   }
    }

    function contactActionChanged(other){
        var otherEntity = other.getBody().target
        var otherEntityType = otherEntity.entityType
        if (otherEntityType === "Spring" &&
                (hero.state ==="falling" || hero.state === "jumping")) {
            // Increase the number of active contacts the player has

            hero.contacts++
            hero.jump(1) // the height of the jump is scaled by 1
            hero.contacts--
        }
        else if (otherEntityType === "Bumper" && Math.abs(otherEntity.x - hero.x) > otherEntity.width/2){
            deactvXVelLimit(1500)
            if(otherEntity.x < hero.x)
                hero.applyVelocity(5000);
            else
                hero.applyVelocity(-5000);
        }

        else if (otherEntityType === "Border")
            hero.die()

        else if (otherEntity.entityType === "TrapDoor")
        {
            var point = mapFromItem(otherEntity, otherEntity.x, otherEntity.y) // we get global x and y of the trapdoor
            //If hero is inside our TrapDoor, and state of trapDoor is open, catch him!
            console.log("hero" + point)
            if(otherEntity.x - 10 <= point.x
                    && otherEntity.y - 10 <= point.y
                    && otherEntity.x + otherEntity.width + 10 >= point.x + width
                    && otherEntity.y + otherEntity.height + 10 >= point.y + height

                    )
            {
                deadTimer.start()
            }
        }


    }
    Timer{
        id:deadTimer
        interval: 500
        onTriggered: {hero.die()
        console.log("zabity")
        }
    }

    //Shape and box collider for CircleHero
    Image{
        id: circleBody
        anchors.fill: parent
        source:"qrc:/assets/pictures/mainshape_circle@3x.png"
        visible: false

        //Shoy energy in our Circle
        ShoyEnergy {
            id: shoyEnergyCircle
            anchors.centerIn: parent
        }
    }

    // HeroCircle collider definition
    CircleCollider {
        id: circleCollider

        property alias state: hero.state
        active: false   //we disable collider at the beggining
        radius: circleBody.width / 2 // radius of the HeroCircle collider
        bodyType: Body.Dynamic
        // For super accurate collision detection, use this sparingly, because it's quite performance greedy
        bullet: true
        sleepingAllowed: false
        // Restitution cause hero to bounce
        restitution: 0  //was 0.4
        // Friction to stop the hero when not moving
        friction: 5.0

        //set size of Hero
        onActiveChanged: {

            if(active === true)
            {
                hero.height = gameScene.height/16
                hero.width = hero.height
            }
       }

        // HeroCircle collision handling
        fixture.onContactChanged: contactActionChanged(other)
        fixture.onBeginContact: contactActionStart(other)
        fixture.onEndContact: contactActionEnded(other)
        //linearVelocity is a parameter, which we choose empirically. However,
        //the intuition tells that the velocity shoud be set according to the scene size.
        onLinearVelocityChanged: {
            if(xVelocityLimit === true){
                if (linearVelocity.x > 500)
                    linearVelocity.x = 500
                if (linearVelocity.x < -500)
                    linearVelocity.x = -500
            }
            if(linearVelocity.y >0)
                jumpFlag = false
        }
    }

    //End of CircleHero

    //Shape and box collider for HeroSquare!

    // HeroSquare body
    Image{
        id: squareBody
        anchors.fill: parent
        source: "qrc:/assets/pictures/maineshape_square@3x.png"
        visible: false

        //ShoyEnergy in our Square
        ShoyEnergy {
            id: shoyEnergySquare
            anchors.centerIn: parent
        }
    }

    // HeroSquare collider definition
    BoxCollider {
        id: squareCollider
        active: false   //we disable collider at the beggining
        anchors.fill: parent
        bodyType: Body.Dynamic
        // For super accurate collision detection, use this sparingly, because it's quite performance greedy
        bullet: true
        sleepingAllowed: false
        // Restitution cause hero to bounce
        restitution: 0
        // Friction to stop the hero when not moving
        friction: 3.0
        //we change density to give our square weight
        density: 0.1

        //set size of Hero
        onActiveChanged: {

            if(active === true)
            {
                hero.height = gameScene.height/16
                hero.width = hero.height
            }
       }

        // HeroSquare collision handling
        fixture.onContactChanged: contactActionChanged(other)
        fixture.onBeginContact: contactActionStart(other)
        fixture.onEndContact: contactActionEnded(other)

        onLinearVelocityChanged: {
            if(xVelocityLimit === true){
                if (linearVelocity.x > 500)
                    linearVelocity.x = 500
                if (linearVelocity.x < -500)
                    linearVelocity.x = -500
            }
            if(linearVelocity.y >0)
                jumpFlag = false
        }
    }

    //End of HeroSquare

    //Shape and box collider for HeroTriangle (we want to make equilateral triangle)

    Image{
        id: triangleBody
        visible: false
        anchors.fill: parent
        source: "qrc:/assets/pictures/mainshape_triangle@3x.png"

        //Shoy energi in our triangle (we change some properties because original don't fit in triangle).
        ShoyEnergy {
            id: shoyEnergyTriangle
            width: parent.width / 2
            height: parent.height / 2
            anchors.bottomMargin: parent.height / 10
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    //our collider for Triangle
    PolygonCollider{
        id: triangleCollider

        //Beggining of creating the collider
        vertices: [
            Qt.point(0, parent.height), // bottom left
            Qt.point(parent.width, parent.height), // bottom right
            Qt.point(parent.width / 2, 0)   //top of the triangle
        ]
        //End of creating the collider

        active: false   //we disable collider at the beggining
        bodyType: Body.Dynamic
        // For super accurate collision detection, use this sparingly, because it's quite performance greedy
        bullet: true
        sleepingAllowed: false
        // Restitution cause hero to bounce
        restitution: 0
        // Friction to stop the hero when not moving
        friction: 5.0
        //we change density to give our square weight
        density: 0.1

        //set size of Hero
        onActiveChanged: {

            if(active === true)
            {
                hero.width = hero.width
                hero.height = hero.height * 0.866
            }
       }

        // HeroTriangle collision handling
        fixture.onContactChanged: contactActionChanged(other)
        fixture.onBeginContact: contactActionStart(other)
        fixture.onEndContact: contactActionEnded(other)

        onLinearVelocityChanged: {
            if(xVelocityLimit === true){
                if (linearVelocity.x > 500)
                    linearVelocity.x = 500
                if (linearVelocity.x < -500)
                    linearVelocity.x = -500
            }
            if(linearVelocity.y >0)
                jumpFlag = false
        }
    }

    //End of heroTriangle
}
