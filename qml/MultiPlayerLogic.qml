/*
  This is multiplayerlogic file. Here we add neccesary connections to our hero which are used to
  send important messages to other players.
  We also load level and start the main game for single and multiplayer
  */

import VPlay 2.0
import QtQuick 2.0
import "scenes"

Item {
    id: multiplayerLogic

    //this properties are codes for our messages
    property int messageLevelData: 3
    property int messageSendDeadFlag: 4
    property int messageUpdateShape: 5
    property int messageUpdatePosition: 6
    property int messageUpdateScore: 7

    //this property turn on sending messages when it's true
    property bool isMultiOn: false

    //Connections for our hero - we send messages when shape, score or position changed
    Connections{
        target: gameScene.hero

        onShapeChanged:{
            if(isMultiOn === true)
            {
                var myMessage = [myMultiplayer.localPlayer.userId, gameScene.hero.shape]
                myMultiplayer.sendMessage(messageUpdateShape, myMessage)
            }
        }

        onYChanged:{
            if(isMultiOn === true)
            {
                var myMessage = [myMultiplayer.localPlayer.userId, gameScene.hero.x, gameScene.hero.y]
                myMultiplayer.sendMessage(messageUpdatePosition, myMessage)
            }
        }

        onXChanged:{
            if(isMultiOn === true)
            {
                var myMessage = [myMultiplayer.localPlayer.userId, gameScene.hero.x, gameScene.hero.y]
                myMultiplayer.sendMessage(messageUpdatePosition, myMessage)
            }
        }

        onDeadFlagChanged:{
            if(isMultiOn === true)
            {
                var myMessage = [myMultiplayer.localPlayer.userId, gameScene.hero.deadFlag]
                myMultiplayer.sendMessage(messageSendDeadFlag, myMessage)
                gameScene.ghost.visible = false
                myMultiplayer.endGame()
            }
        }

        onScoreChanged:{
            if(isMultiOn === true)
            {
                var myMessage = [myMultiplayer.localPlayer.userId, gameScene.hero.score]
                myMultiplayer.sendMessage(messageUpdateScore, myMessage)
            }
        }
    }

    //connections for our VPlayMultiplayer
    Connections{
        target: myMultiplayer
        onGameStarted: {
            //the host player has scene to choose level, the guest is still waiting
           if(myMultiplayer.amLeader)
           {
                chooseLevelScene.state = "basic"
                window.state = "chooseLevel"
           }

           //we turn on everything what we need for multiplayer
           isMultiOn = true

           gameScene.ghost.enabled = true
           gameScene.ghost.state = gameScene.hero.shape
           gameScene.ghost.playerID = myMultiplayer.connectedPlayers[1]
           gameScene.ghost.score = 0
        }

        onGameEnded:{
            gameScene.ghost.enabled = false
            gameScene.ghost.visible = false
            isMultiOn = false
        }

        //when other player left we continue as normal singleplayer
        onPlayerLeft:{
            gameScene.ghostInfoText.state = "playerLeft"
            gameScene.ghostInfoText.showText()
            gameScene.ghost.enabled = false
            gameScene.ghost.visible = false
            isMultiOn = false
        }

        //here we take care of important messages
        onMessageReceived:{

            //if our message is one of these we are interessed
            if(code === messageSendDeadFlag || code === messageUpdatePosition || code === messageUpdateShape
                    || code === messageLevelData || code === messageUpdateScore)
            {
                var playerID = message[0]
                //when the message tells us the shape of player changed
                if(code === messageUpdateShape)
                {
                    gameScene.ghost.shape = message[1]
                }

                //when the position of player changed
                else if(code === messageUpdatePosition)
                {
                    gameScene.ghost.updatePosition(message[1], message[2])
                }

                //when player die
                else if(code === messageSendDeadFlag)
                {
                    gameScene.ghost.visible = false
                    gameScene.ghostInfoText.state = "ghostDie"
                    gameScene.ghostInfoText.showText()
                }

                //update score of ghost
                else if(code === messageUpdateScore)
                {
                    gameScene.ghost.updateScore(message[1])
                }

                //Here we start game on client game and set up the ghost
                else if(code === messageLevelData && myMultiplayer.amLeader === false)
                {
                    //prepare ghost
                    gameScene.ghost.enabled = true
                    gameScene.ghost.visible = true
                    gameScene.ghost.state = gameScene.hero.shape
                    gameScene.ghost.playerID = myMultiplayer.connectedPlayers[0]

                    //turn on the game
                    levelEditor.loadSingleLevel(message)
                    gameWindow.state = "game"
                    gameScene.state = "play"
                    gameScene.reloadScene()
                }
            }
        }
    }    

    //here we turn on game - single and multiplayer
    Connections{
        target: chooseLevelScene.levelSelection

        onLevelSelected: {
            // load level
            levelEditor.loadSingleLevel(levelData)

            //if it's multiplayer, send levelinfo to other player
            if(isMultiOn)
                myMultiplayer.sendMessage(messageLevelData, levelData)

            // switch to gameScene, play mode
            gameWindow.state = "game"
            gameScene.state = "play"

            // initialize level
            gameScene.reloadScene()

            //show ghost
            if(myMultiplayer.amLeader === true)
                gameScene.ghost.visible = true
        }
    }
}
