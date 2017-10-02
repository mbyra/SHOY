/*
  This is MovableShelf game object. It's an obstacle, which can block hero while he jump or hero can jump on it.
  MovableShelf has just two states - move left and move right. They move all the time.
  When hero jump on the MovableShelf, he move with it. Default shelf start move to the right
  Duration and range of move can be changed when object is created.
*/
import QtQuick 2.7
import VPlay 2.0


/*
  To do:
  - w momencie wykrycia kolizji z innym obiektem niz hero zmieniamy stan obiektu i leci w przeciwna strone
  - gdy hero skoczy na polke to ma sie z nia przemieszczac w prawo/lewo (a przynajmniej do czasu az zmienimy
  zalozenia polki.
  */
EntityBaseDraggable {
    id: lift
    entityType: "Lift"

    //levelEditor properties
    colliderComponent: rangeCollider
    selectionMouseArea.anchors.fill: rangeRect
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()

    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true

    //size of our shelf
    width: gameScene.width / 6
    height: shelfHeight*8
    property int shelfHeight: gameScene.height / 30

    property string direction: "up"

    // use this function to pause animation
    function pauseAnimation() {
        if(moveUp.running){
            moveUp.pause()
        }
        else if(moveDown.running){
            moveDown.pause()
        }
    }

    // use this function to resume animation
    function resumeAnimation() {
        if(moveDown.paused)
            moveDown.resume()
        else if(moveUp.paused) {
            moveUp.resume()
        }
    }

    Rectangle{
        id: liftShelf
        y: parent.height/2 - shelfHeight/2
        x: 0
        height: parent.shelfHeight
        width:parent.width
    }

    //Here we load image.
    Image {
        id: liftImg
        anchors.fill: liftShelf
        source: "qrc:/assets/pictures/shape_03_03@3x.png"
    }
    NumberAnimation{
        id:moveUp
        running: true
        target:liftShelf; property: "y"; to:0
        duration:3000
        onStopped: {moveDown.start();direction="down"}
    }
    NumberAnimation{
        id:moveDown
        target:liftShelf; property: "y"; to:lift.height
        duration: 3000
        onStopped: {moveUp.start();direction="up"}
    }
    //Collider for our shelf.
    BoxCollider {
        id: liftShelfCollider
        anchors.fill: parent
        bodyType: Body.Static
        gravityScale: 0 //turning off gravity force from this body
        friction: 0 // this set our shelf slippery and hero cannot hang on shelf

    }
    BoxCollider {
        id: rangeCollider
        bodyType: Body.Static
        gravityScale: 0
        anchors.fill:parent
    }
    Rectangle{
        id: rangeRect
        anchors.fill: rangeCollider
        color:"gray"
        opacity: 0.5
    }

    Connections{
        target: gameScene
        onRunningChanged:{
            if(gameScene.running === true){
                rangeCollider.active = false
                rangeRect.visible = false
                liftImg.visible = true
                resumeAnimation()
            }
            else if(gameScene.running === false){
                rangeCollider.active = true
                rangeRect.visible = true
                pauseAnimation()
            }
        }
    }

    Component.onCompleted: {
        pauseAnimation()
    }
}
