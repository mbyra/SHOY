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
    id: movableShelf
    entityType: "MovableShelf"

    //levelEditor properties
    colliderComponent: shelfCollider
    selectionMouseArea.anchors.fill: shelfImg
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()

    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)

    //size of our shelf
    width: gameScene.width / 6
    height: gameScene.height / 30
    property string direction: "right"

    // use this function to pause animation
    function pauseAnimation() {
        if(moveRight.running){
            moveRight.pause()
        }
        else if(moveLeft.running){
            moveLeft.pause()
        }
    }

    // use this function to resume animation
    function resumeAnimation() {
        if(moveLeft.paused)
            moveLeft.resume()
        else if(moveRight.paused) {
            moveRight.resume()
        }
    }

    //Here we load image.
    Image {
        id: shelfImg
        anchors.fill: parent
        source: "qrc:/assets/pictures/MovableShelf.png"
    }

    NumberAnimation{
        id:moveRight
        running: true
        target:movableShelf; property: "x"; to:gameScene.width - movableShelf.width
        duration:5000
        onStopped: {moveLeft.start();direction="left"}
    }
    NumberAnimation{
        id:moveLeft
        target:movableShelf; property: "x"; to:gameScene.x; duration: 5000
        onStopped: {moveRight.start();direction="right"}
    }
    //Collider for our shelf.
    BoxCollider {
        id: shelfCollider
        anchors.fill: parent
        bodyType: Body.Static
        gravityScale: 0 //turning off gravity force from this body
        friction: 0 // this set our shelf slippery and hero cannot hang on shelf

    }

    BoxCollider {
        id: rangeCollider
        bodyType: Body.Static
        gravityScale: 0
        width: gameScene.width*0.9
        anchors.horizontalCenter: parent
        anchors.verticalCenter: parent
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
                shelfImg.visible = true
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
