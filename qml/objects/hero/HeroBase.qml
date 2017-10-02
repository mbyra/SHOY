/*
 * This is definition of the HeroBase object.
 * From this object all heroes inherits funtions, atributtes, states, moves etc.
 * Main hero has 3 colliders - circleCollider, squareCollider and triangleCollider (They are defined in hero.qml)
 */

import QtQuick 2.0
import VPlay 2.0

EntityBaseDraggable {
    id: heroBaseEntity // the id we use as a reference inside this class
    // EntityType name
    entityType: "Hero"

    property bool deadFlag: false
    property bool jumpFlag: false
    // Make the hero's twoAxisController visible and accessible for the scene
    property alias controller: twoAxisController
    // The contacts property is used to determine if the player is in touch with any solid objects (like platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
    property int contacts: 0
    //this property set our shape - choose between "circle", "triangle", "square"
    property string shape
    // Player's current score
    property int score: 0
    // Property which holds y position of the highest reached platform
    property int platformLevelHight: 0
    signal inverseGravity
    property bool xVelocityLimit: true

    // Hero dies and appears again
    function die() {
        timer.stop()
        deadFlag = true
    }

    //linearVelocity is a parameter, which we choose empirically. However,
    //the intuition tells that the velocity shoud be set according to the scene size.
    // " - " is neded because y axis is increasing in direction of the bottom of the screen
    function jump(x) {
        if (heroBaseEntity.state === "walking") {
            jumpFlag = true
            if(x === null)
                x = 0.5
            // for the jump, we simply set the upwards velocity of the collider
            console.log("jump")
            circleCollider.linearVelocity.y = -1500 * x
            squareCollider.linearVelocity.y = -1500 * x
            triangleCollider.linearVelocity.y = -1500 * x
        }
    }

    /*
     * This function applies linear velocity on x axis
     */
    function applyVelocity(v){
        circleCollider.linearVelocity.x = v
        squareCollider.linearVelocity.x = v
        triangleCollider.linearVelocity.x = v
    }

    /*
     * This function disable x velocity limit for the given amount of time t
     */
    function deactvXVelLimit(t){
        xVelocityLimitTimer.interval = t
        xVelocityLimitTimer.running = true
    }

    //reseting our hero
    function resetHeroBase()
    {
        circleCollider.linearVelocity.x = 0
        circleCollider.linearVelocity.y = 0
        squareCollider.linearVelocity.x = 0
        squareCollider.linearVelocity.y = 0
        triangleCollider.linearVelocity.x = 0
        triangleCollider.linearVelocity.y = 0
        squareCollider.angularVelocity = 0
        triangleCollider.angularVelocity = 0

        contacts = 0
        score = 0
        platformLevelHight = gameScene.height / 4 * 3
        collidersActive = true
        deadFlag = false
        jumpFlag = false
        shape = "circle"
    }

    // This function is triggered when hero collides with TopBorder object
    function win() {
        window.state = "levelCompleted"
    }

    // Function which updates hero score with the given
    // number of points
    function updateScore(points)
    {
        score += points;
        scoreBar.score = hero.score;
    }

    function setPlatformLevelHight(x)
    {
        platformLevelHight = x;
    }

    width: height
    height: gameScene.height/16

            onInverseGravity: {
                physicsWorld.gravity.y = -physicsWorld.gravity.y
                console.log("inversed")
            }

    preventFromRemovalFromEntityManager: true
    //Here we change the shape of our hero.
    //To do that we have to turn on right Body and Collider - rest turn off
    onShapeChanged: {

        if(shape === "circle")
        {
            circleBody.visible = true
            circleCollider.active = true
            triangleBody.visible = false
            triangleCollider.active = false
            squareBody.visible = false
            squareCollider.active = false
        }

        else if(shape === "square")
        {
            circleBody.visible = false
            circleCollider.active = false
            triangleBody.visible = false
            triangleCollider.active = false
            squareBody.visible = true
            squareCollider.active = true
        }

        else if(shape === "triangle")
        {
            circleBody.visible = false
            circleCollider.active = false
            triangleBody.visible = true
            triangleCollider.active = true
            squareBody.visible = false
            squareCollider.active = false
        }
    }

    onStateChanged: {
        console.log("STAN BOHATERA: " + hero.state)
        if(state === "dead")
            window.state = "gameOver"
    }

    // Hero uses TwoAxisController to move the hero left or right.
    TwoAxisController {
        id: twoAxisController

        onInputActionPressed: {

             if (actionName == "up") {
                jump(0.5)
            }
        }

        //we start our timer when xAxis change - it changes when we press button or touch the screen
        onXAxisChanged: timer.restart()
    }

    //We use this timer to change the linear velocity of our square and triangle.
    //When the key is pressed, the timer is running, checking the xAxis and if it is 1 or -1, we move left or right
    Timer{
        id: timer
        interval: 100
        repeat: true
        onTriggered: {

            //we cannot see if circle is rotating, so we just change linear velocity
            circleCollider.linearVelocity.x = controller.xAxis * 1000

            //we want to rotate our triangle and square when it's walking
            if(hero.state === "walking")
            {
                squareCollider.angularVelocity = controller.xAxis * 300
                triangleCollider.angularVelocity = controller.xAxis * 500
            }

            //when hero it's flying, we change linearvelocity to move him
            else if(hero.state === "jumping" || hero.state === "falling")
            {
                squareCollider.linearVelocity.x = controller.xAxis * 1000
                triangleCollider.linearVelocity.x = controller.xAxis * 1000
            }
        }
    }

    Timer{
        id: xVelocityLimitTimer
        interval: 500
        onRunningChanged: {
            if(running === false){
                xVelocityLimit = true
                timer.running = true
            }
            else{
                xVelocityLimit = false
                timer.running = false
            }
        }
    }

    // Change state according to the hero's y velocity
    state: {
        if(deadFlag)
            return "dead"

         if(jumpFlag)
            return "jumping"

        else if(contacts > 0)
            return "walking"

        else if(contacts === 0 && jumpFlag === false)
            return "falling"
         else{
             console.log("_________STAN NIEZDEFINIOWANY!!!!_________contacts: " + contacts + ", jumpFlag: " + jumpFlag )
             return "walking"
         }
    }
}
