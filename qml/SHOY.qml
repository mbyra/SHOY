
// This is entrance point to the application.
// It contains GameWindow element, entity manager, all possible scenes
// (such as menu, settings, game, pause, etc.) and state machine, which
// takes care for changing the visible state.
import VPlay 2.0
import QtQuick 2.0
import "scenes"
import "controls"
import "../"
GameWindow {
    id: window

    property int baseSceneWidth: menuScene.width
    property int baseSceneHeight: menuScene.height
    property alias gameNetwork: gameNetwork
    property alias shoyFont: shoyFont
    property alias gameNetworkScene: gameNetworkScene
    property alias score: gameScene.score
    property alias levelEditor: levelEditor

    width: 540
    height: 960

    // Main menu is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    FontLoader {
        id: shoyFont
        source: "qrc:/assets/FredokaOne-Regular.ttf"
    }

    EntityManager {
        id: entityManager

        // Container has to be set to the appropriate object
        entityContainer: gameScene.container
        // Pooling improves performance
        poolingEnabled: true
    }

    // Component for managing SHOY's network features (player accounts, global highscores etc.)
    VPlayGameNetwork {
        id: gameNetwork
        gameId: 397
        secret: "ccb5338cf40bb6f0519cd86efd5e806c"
        gameNetworkView: gameNetworkScene.gameNetworkView
        multiplayerItem: myMultiplayer
        clearAllUserDataAtStartup: true // removes previously cached user-data
    }

    //This component is core of our multiplayer. With it it's possible to join the lobby and start multiplayer.
    VPlayMultiplayer {
        id: myMultiplayer
        playerCount: 2
        appKey: "4dcad341-9509-4562-a20a-92e060953573"
        gameNetworkItem: gameNetwork
        multiplayerView: multiplayerLobbyScene.multiplayerView
    }

    //this component contain logic for our multiplayer - neccesary connections and other things.
    MultiPlayerLogic { id: multiplayerLogic }

    LevelEditor{
        id:levelEditor
        toRemoveEntityTypes: [ "SlopeLeft","SlopeRight","Spring","MovableShelf","SolidPlatform",
            "TrapDoor","WoodenPlatform", "Stone", "Bumper", "Labirynth", "VictoryPlatform", "Lift",
            "TriangleWallFacingLeft", "TriangleWallFacingRight"]
        toStoreEntityTypes: [ "SlopeLeft","SlopeRight","Spring","MovableShelf","SolidPlatform",
            "TrapDoor","WoodenPlatform","Stone", "Bumper", "Labirynth", "VictoryPlatform", "Lift",
            "TriangleWallFacingLeft","TriangleWallFacingRight"]
        applicationJSONLevelsDirectory: "levels/"
        Component.onCompleted: loadAllLevelsFromStorageLocation(levelEditor.authorGeneratedLevelsLocation)

    }


    // All scenes in our game:
    MenuScene {
        id: menuScene
    }

    HowToPlayScene {
        id: howToPlayScene
    }

    GameNetworkScene {
        id: gameNetworkScene
    }

    SettingsScene {
        id: settingsScene
    }

    CreditsScene {
        id: creditsScene
    }

    //TODO opoznic zaczynanie gry do przejscia na ten ekran
    GameScene {
        id: gameScene
    }

    GameOverScene {
        id: gameOverScene
    }

    LevelCompletedScene {
        id: levelCompletedScene
    }

    PlayGameScene {
        id: playGameScene
    }

    MultiplayerLobbyScene {
        id: multiplayerLobbyScene
    }

    ChooseLevelScene{
        id: chooseLevelScene
    }

    AskScene {
        id: askForQuitScene
        question: "Are you sure want to quit?"
        acceptMouseArea.onClicked: Qt.quit()
        denyMouseArea.onClicked: window.state = "menu"
    }

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {
                target: menuScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: menuScene
            }
        },
        State {
            name: "chooseLevel"
            PropertyChanges {target: chooseLevelScene; opacity: 1}
            PropertyChanges {target: window; activeScene: chooseLevelScene}
            PropertyChanges {target: chooseLevelScene; state: "basic"}
//            PropertyChanges {target: chooseLevelScene;
        },
        State {
            name: "howToPlay"
            PropertyChanges {
                target: howToPlayScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: howToPlayScene
            }
        },
        State {
            name: "gameNetwork"
            PropertyChanges {
                target: gameNetworkScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: gameNetworkScene
            }
        },
        State {
            name: "settings"
            PropertyChanges {
                target: settingsScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: settingsScene
            }
        },
        State {
            name: "credits"
            PropertyChanges {
                target: creditsScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: creditsScene
            }
        },
        State {
            name: "askForQuit"
            PropertyChanges {
                target: askForQuitScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: askForQuitScene
            }
        },
        State {
            name: "levelEditor"
            PropertyChanges {
                target: gameScene
                opacity: 1
            }
            PropertyChanges {
                target: gameScene
                state: "edit"
            }
            PropertyChanges {
                target: window
                activeScene: gameScene
            }
        },
        State {
            name: "game"
            PropertyChanges {
                target: gameScene
                opacity: 1
            }
            PropertyChanges {
                target: gameScene
                state: "game"
            }
            PropertyChanges {
                target: window
                activeScene: gameScene
            }
        },
        State {
            name: "levelCompleted"
            PropertyChanges {
                target: levelCompletedScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: levelCompletedScene
            }
        },
        State {
            name: "gameOver"
            PropertyChanges {
                target: gameOverScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: gameOverScene
            }
        },
        State {
            name: "playGame"
            PropertyChanges {
                target: playGameScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: playGameScene
            }
        },

        State {
            name: "multiplayerLobby"
            PropertyChanges {
                target: multiplayerLobbyScene
                opacity: 1
            }
            PropertyChanges {
                target: window
                activeScene: multiplayerLobbyScene
            }
        }
    ]

    onStateChanged: {
        if (state === "game" || state === "levelEditor")
            gameScene.reloadScene()
        if (state === "levelCompleted")
            gameScene.deactivateGameBoard()
    }
}
