/*
 * This is definition of the GameScene object.
 * GameScene presents board with the player
 * and all items which player can interact with.
 * It contains specific backgound graphics. Also
 * GameScene includes gravity and special fetures
 * as accelerometer handling.
 */
import VPlay 2.0
import QtQuick 2.5
import QtSensors 5.5
import "../objects"
import "../objects/hero"
import "../controls/buttons"
import "../objects/hero"
import "../objects/interactive"
import "../objects/static"
import shoy.utils.timer 1.0

BaseScene {
    id: gameScene

    property alias mouseArea: mainMouseArea
    property alias physicsWorld: physicsWorld
    property real wallWidth: gameScene.width / 64
    property alias hero: hero
    property alias ghost: testGhost
    property alias ghostInfoText: ghostInfoText
    property alias container: viewPort
    property alias score: scoreBar.score
    property alias pauseState: pause.pauseState

    property int killBorderY: camera.freePosition.y + 1920 - hero.height
    property bool running: false

    // Function which reloads game scene - brings hero back to the screen
    function reloadScene() {
        deactivateGameBoard()
        hero.x = gameScene.width / 2
        hero.y = gameScene.height * 2 / 3 // this should be set to 0 otherwise it cause
        scoreBar.score = 0
        savePopUp.visible = false

        //player to move at the start of the game without touching the screen or key
        physicsWorld.gravity.y = 36
        camera.centerFreeCameraOn(hero.x, hero.y)
        mainMouseArea.doubleClicked.connect(hero.jump)
        hero.resetHero()
        viewPort.reset()
        shapeChangeButton.state = "circle"

        if (state === "edit") {
            pause.pauseState = true
            deactivateGameBoard()
        } else {
            pause.pauseState = false
            activateGameBoard()
        }
    }

    // Function used to deactivate board e.g. in pause mode
    function deactivateGameBoard() {
        hero.collidersActive = false
        hero.pauseAnimation()

        if (state !== "edit")
            physicsWorld.running = false

        gameTimer.stop()
        boardMovingUpdateTimer.running = false
        running = false
    }

    // Function used to activate board e.g. after pause mode
    function activateGameBoard() {
        hero.collidersActive = true
        hero.resumeAnimation()
        //level.resumeAnimations()
        physicsWorld.running = true
        gameTimer.start()
        boardMovingUpdateTimer.running = true
        running = true
    }

    //function which checks if player should die, because he reached bottom of the board
    function checkGameEndConditions() {
        if (running) {
            // Check if the hero collides with bottom of the screen
            if (hero.y >= killBorderY) {
                hero.die()
                deactivateGameBoard()
            }
        }
    }

    // saves the current level
    function saveLevel() {
        // initialize save properties
        var saveProperties = {
            levelMetaData: {

            },
            customData: {

            }
        }

        // save level name
        saveProperties.levelMetaData.levelName = levelEditor.currentLevelName

        // save current background
        // TODO in future it will be easy to keep background image of the level
        //      saveProperties.customData.background = bgImage.bg;
        //      // save player's position
        saveProperties.customData.playerX = hero.x
        saveProperties.customData.playerY = hero.y

        // execute save
        levelEditor.saveCurrentLevel(saveProperties)
        levelEditor.exportLevelAsFile()
    }

    Keys.forwardTo: hero.controller

    state: "play"
    states: [
        State {
            name: "play"
        },
        State {
            name: "edit"
        }
    ]

    // Set background image
    Image {
        anchors.fill: parent
        source: "qrc:/assets/pictures/background@3x.png"
    }

    //This mouse area let us to play with mouse or touchpad.
    //We want to player move left when we touch left part of the screen and
    //to move right when we touch right part of the screen.
    //Middle part of the screen don't make hero move. Double click/touch make hero jump.
    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        onDoubleClicked: hero.jump(0.5)
    }

    // Timer which counts game time
    GameTimer {
        id: gameTimer
    }
    // Timer for game board moving down
    Timer {
        id: boardMovingUpdateTimer
        interval: 20
        running: false
        repeat: true
        //triggeredOnStart: false;
        onTriggered: {
            var distToCeil = hero.y - camera.freePosition.y
            if (distToCeil < gameScene.height / 2)
                viewPort.boardSpeedupCoeff = gameScene.height / 2 / (distToCeil)
            else
                viewPort.boardSpeedupCoeff = 1.0
            var tmp = -(viewPort.boardVelocity * interval / 1000 * viewPort.boardSpeedupCoeff)
            camera.moveFreeCamera(0, tmp)
        }
    }

    // camera
    CameraVPlay {
        id: camera

        // set the gameWindowSize and entityContainer with which the camera works with
        gameWindowSize: Qt.point(
                            gameScene.width,
                            gameScene.height) //gameScene.gameWindowAnchorItem.width, gameScene.gameWindowAnchorItem.height)
        entityContainer: viewPort

        // disable the camera's mouseArea, since we handle the controls of the free
        // moving camera ourself, in EditorUnderlay
        allowZoomWithFocus: false
        mouseAreaEnabled: {
            if (gameScene.state === "edit" && pause.pauseState === true) {
                return true
            } else
                return false
        }
        limitLeft: 0
        limitRight: gameScene.width
    }

    // This is the moving item containing the level and player
    Item {
        id: viewPort
        transformOrigin: Item.TopLeft

        function reset() {
            boardVelocity = 100
            boardSpeedupCoeff = 1.0
        }

        onYChanged: checkGameEndConditions()

        // Game board scrolling velocity
        property real boardVelocity: 100
        property real boardSpeedupCoeff: 1.0
        // Turn on gravity and collisions
        PhysicsWorld {
            id: physicsWorld

            debugDrawVisible: true // set this to true to show the physics overlay
            updatesPerSecondForPhysics: 60
            gravity.y: 36 // gravity strength

            onPreSolve: {
                //this is called before the Box2DWorld handles contact events
                var entityA = contact.fixtureA.getBody().target
                var entityB = contact.fixtureB.getBody().target
                // If there is collistion between WoodenPlatform and hero when hero jumps, disable contact
                if ((entityA.entityType === "WoodenPlatform"
                     && entityB.entityType === "Hero"
                     && entityB.state === "jumping")
                        || entityA.entityType === "Spring"
                        && entityB.entityType === "Hero"
                        && entityB.state === "jumping") {
                    //by setting enabled to false, they can be filtered out completely
                    //-> disable cloud platform collisions when the player is below the platform
                    contact.enabled = false
                }

                //this condition is the same like above, but there is a chance to entityA will be a hero,
                //so we just change order
                if (((entityA.entityType === "Hero"
                      && entityB.entityType === "WoodenPlatform")
                     && entityA.state === "jumping")
                        || (entityB.entityType === "Spring"
                            && entityA.entityType === "Hero"
                            && entityA.state === "jumping")) {

                    //by setting enabled to false, they can be filtered out completely
                    //-> disable cloud platform collisions when the player is below the platform
                    contact.enabled = false
                }

                //We disable collision between trapdoor and Hero - we want to let hero enter the TrapDoor
                if ((entityA.entityType === "TrapDoor"
                     && entityB.entityType === "Hero")
                        || entityA.entityType === "Hero"
                        && entityB.entityType === "TrapDoor")
                    contact.enabled = false
            }
        }

        //test Ghost
        Ghost {
            id: testGhost
            enabled: false
            visible: false
        }

        Hero {
            id: hero
            shape: "circle"
        }
    }

    //HERO CONTROLLS
    //Buttons
    Item {
        id: leftArrow
        anchors.bottom: gameScene.bottom
        anchors.left: gameScene.left
        anchors.right: shapeChangeButton.left
        anchors.rightMargin: 20
        opacity: 0.5
        height: 300
        MouseArea {
            anchors.fill: parent
            onPressed: hero.controller.xAxis = -1
            onReleased: hero.controller.xAxis = 0
            onDoubleClicked: hero.jump(0.5)
        }
        Image {
            id: leftArrowImage
            anchors.centerIn: parent
            source: "qrc:/assets/pictures/button_arrow_normal@3x.png"
        }
    }
    Item {
        id: rightArrow
        anchors.bottom: gameScene.bottom
        anchors.right: gameScene.right
        anchors.left: shapeChangeButton.right
        anchors.leftMargin: 20
        height: 300
        opacity: 0.5
        MouseArea {
            anchors.fill: parent
            onPressed: hero.controller.xAxis = 1
            onReleased: hero.controller.xAxis = 0
            onDoubleClicked: hero.jump(0.5)
        }
        Image {
            id: rightArrowImage
            anchors.centerIn: parent
            mirror: true
            source: "qrc:/assets/pictures/button_arrow_normal@3x.png"
        }
    }

    // Button which will allow to change form of the player
    ChangeHeroButton {
        id: shapeChangeButton
    }

    //left wall which don't let hero to leave the tower
    Wall {
        id: leftWall
        height: 6720 * 2
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
    }

    //right wall which don't let hero to leave the tower
    Wall {
        id: rightWall
        height: 6720 * 2
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
    }

    // Screen which makes the GameScene less visible during pause
    Rectangle {
        id: pauseShadeScreen
        anchors.fill: parent
        opacity: 0
        color: "black"
    }

    // PauseButton allows player to get into pause screen in wchich game is in hold
    PauseButton {
        id: pause

        property bool pauseState: false

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }

        onPauseStateChanged: {
            if (pauseState) {
                deactivateGameBoard()
                if (gameScene.state === "game")
                    pauseShadeScreen.opacity = 0.8
            } else {
                activateGameBoard()
                pauseShadeScreen.opacity = 0.0
            }
        }

        onClicked: {
            pauseState ^= true
        }
    }

    ScoreBar {
        id: scoreBar
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
    }

//    SaveButton {
//        id: saveButton
//        visible: gameScene.state == "edit"
//        anchors {
//            top: parent.top
//            right: goBack.left
//            topMargin: 10
//            rightMargin: 10
//        }
//    }

    BackButton {
        id: goBack

        anchors {
            top: parent.top
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (gameScene.state === "play") {
                    window.state = "menu"
                } else
                    savePopUp.visible = true
                deactivateGameBoard()
            }
        }
    }

    Item {
        id: savePopUp
        anchors.centerIn: parent
        visible: false
        width: imageOfPopUp.width
        height: imageOfPopUp.height
        Image {
            id: imageOfPopUp
            anchors.centerIn: parent
            source: "qrc:/assets/pictures/popup_save_all@3x.png"
        }
        MouseArea {
            anchors {
                right: parent.right
                left: parent.horizontalCenter
                bottom: parent.bottom
                top: questionText.bottom
            }
            onClicked: window.state = "menu"
        }
        MouseArea {
            anchors {
                left: parent.left
                right: parent.horizontalCenter
                bottom: parent.bottom
                top: questionText.bottom
            }
            onClicked: {
                nativeUtils.displayTextInput(
                            "Enter level name",
                            "Enter a level name. (3-15 characters)", "",
                            levelEditor.currentLevelName)
                window.state = "menu"
            }

            // this listens for the end of the native text input dialog
            Connections {
                target: nativeUtils

                onTextInputFinished: {
                    // if the text input dialog is closed
                    // and the user clicked "ok"
                    if (accepted) {

                        // the text can't be longer than 9 characters
                        if (enteredText.length > 15) {
                            nativeUtils.displayMessageBox(
                                        "Invalid level name",
                                        "A maximum of 15 characters is allowed!")
                            return
                        } else if (enteredText.length < 3) {
                            nativeUtils.displayMessageBox(
                                        "Invalid level name",
                                        "A minimum of 3 characters is needed!")
                            return
                        }

                        // change level name
                        levelEditor.currentLevelName = enteredText
                        gameScene.saveLevel()
                        savedTextAnimation.restart()
                    }
                }
            }
        }

        Text {
            id: questionText
            font.family: shoyFont.name
            anchors {
                top: parent.top
                bottom: parent.verticalCenter
                left: parent.left
                right: parent.right
                margins: gameScene.dp(5)
            }
            text: "Do you want to save the level?"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font {
                pixelSize: gameScene.dp(20)
                bold: false
            }
            color: "white"
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    ///////////////////LEVEL EDITOR//////////////////////////////////////////////////////
    //Buttons which allows dynamic creation of objects
    Flickable{
        visible: gameScene.state === "edit" && pauseState === true

        anchors {
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            right: parent.right
        }
        height: 200
        flickableDirection: Flickable.HorizontalFlick
         boundsBehavior: Flickable.DragAndOvershootBounds
        contentWidth: entitySelectionBar.width
        clip:true
    Row {
        id: entitySelectionBar
       anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right
        spacing: 10

        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityTypeUrl: "../objects/static/SlopeRightFacing.qml"
            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/slope_orange.png"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100

            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/static/SlopeLeftFacing.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/slope_orange.png"
                mirror: true
            }
        }
        BuildEntityButton {
            width: 100
            height: 100

            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityTypeUrl: "../objects/interactive/Spring.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/SpringItem.png"
            }
        }
        BuildEntityButton {
            width: 100
            height: 100
            // creationProperties: {"parent":level}
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/MovableShelf.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/MovableShelf.png"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100
            // creationProperties: {"parent":level}
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/Lift.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/shape_03_03@3x.png"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100
            //creationProperties: {"parent":level}
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/TrapDoor.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/TrapDoor.png"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/WoodenPlatform.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/soft_platform_cyan.png"
            }
        }

        BuildEntityButton{
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/VictoryPlatform.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
              // make it the size of the parent
              anchors.fill: parent
              source: "qrc:/assets/pictures/shape_13@3x.png"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/interactive/Labirynth.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Rectangle {
                // make it the size of the parent
                anchors.fill: parent
                color: "blue"
            }
        }

        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/SolidPlatformVaringSize.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                // make it the size of the parent
                anchors.fill: parent
                source: "qrc:/assets/pictures/brickwall_small@3x.png"
            }
        }
        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/interactive/Stone.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Rectangle {
                id: rect
                anchors.fill: parent
                color: "grey"
                radius: width / 2
            }
        }
        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityType: "../objects/interactive/Bumper.qml"

            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
              // make it the size of the parent
              anchors.fill: parent
              source: "qrc:/assets/pictures/BumperItem.png"
            }
        }
        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityTypeUrl: "../objects/static/TriangleWallFacingRight.qml"
            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                x:0
                y:parent.height/2
                width: parent.width
                height: parent.height/2
                source: "qrc:/assets/pictures/shape_14@3x.png"
            }
            Image {
                // make it the size of the parent
                x:0
                y:0
                width: parent.width
                height: parent.height/2
                rotation: 180
                mirror: true
                source: "qrc:/assets/pictures/shape_14@3x.png"
            }

        }
        BuildEntityButton {
            width: 100
            height: 100
            // an instance of this entity is created when the entity is dragged to a free spot in the level
            toCreateEntityTypeUrl: "../objects/static/TriangleWallFacingLeft.qml"
            // this is decoupled from the entity, can be set to any QML element that should be displayed
            Image {
                x:0
                y:parent.height/2
                width: parent.width
                height: parent.height/2
                mirror: true
                source: "qrc:/assets/pictures/shape_14@3x.png"
            }
            Image {
                // make it the size of the parent
                x:0
                y:0
                width: parent.width
                height: parent.height/2
                rotation: 180

                source: "qrc:/assets/pictures/shape_14@3x.png"
            }

        }
    }
    }

    //ghost info text - it shows info of our ghost
    Text {
        id: ghostInfoText

        function showText() {
            textAnimation.restart()
        }

        // text and text color
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        color: "#ffffff"
        font.pixelSize: gameScene.dp(20)
        font.family: shoyFont.name

        // by default this text is opaque/invisible
        opacity: 0

        // outline the text, to increase it's visibility
        style: Text.Outline
        styleColor: "#009900"

        // this animation shows and slowly fades out the save text
        NumberAnimation on opacity {
            id: textAnimation

            // slowly reduce opacity from 1 to 0
            from: 1
            to: 0

            // duration of the animation, in ms
            duration: 3000
        }

        //two states - one shows info when ghost die, other one when ghost leave the game.
        states: [
            State {
                name: "ghostDie"
                PropertyChanges {
                    target: ghostInfoText
                    text: "Other player died! His score:" + ghost.score
                }
            },

            State {
                name: "playerLeft"
                PropertyChanges {
                    target: ghostInfoText
                    text: "Other player left! His score:" + ghost.score
                }
            }
        ]
    }
} /////////////////////////////////////////////////////////////////////////////////////
