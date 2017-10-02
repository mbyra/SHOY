// This is the scene which is displayed at the start of the game.
// It contains buttons:
// * New Game
// * High Scores
// * Settings
// * Credits
// * Quit
import VPlay 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtMultimedia 5.5
import "../controls/buttons"

BaseScene {
    id: menuScene

    signal newGamePressed
    signal highscoresPressed
    signal settingsPressed
    signal creditsPressed
    signal quitPressed

    backgroundImage: "qrc:/assets/pictures/mainmenu_background.png"

    //ShoyImage
        Image{
        id:shoyTitle
        anchors{horizontalCenter: parent.horizontalCenter;top:parent.top}
        source: "qrc:/assets/pictures/shoy_title.png"

        fillMode: Image.Pad
        }
    // menu
    Column {
        id: column
        spacing: menuScene.dp(11)
        y:shoyTitle.y + shoyTitle.height*4/5
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 20
        }

        DefaultButton {
            text: "New Game"
            onClicked: {
                //shoyMusic.play()
                window.state = "playGame"
            }

            textPixelSize: menuScene.sp(21)
        }


        DefaultButton {
            text: "How to play"
            onClicked: {
                window.state = "howToPlay"
            }

            textPixelSize: menuScene.sp(21)
        }
        DefaultButton {
            text: "Level Editor"
            onClicked: {
                var creationProperties = {
                  levelMetaData: {
                    levelName: "newLevel"
                  }
                }
                levelEditor.createNewLevel(creationProperties)

                window.state = "levelEditor"
                gameScene.state = "edit"
                gameScene.reloadScene()
            }

            textPixelSize: menuScene.sp(21)
        }

        DefaultButton {
            text: "Your Profile"
            onClicked: {
                parent.scale = 1.0
                window.state = "gameNetwork"
                window.gameNetwork.showProfileView()
            }

            textPixelSize: menuScene.sp(21)
        }

        DefaultButton {
            text: "Credits"
            onClicked: {
                window.state = "credits"
            }

            textPixelSize: menuScene.sp(21)
        }
        DefaultButton {
            text: "Quit"
            onClicked: {
                window.state = "askForQuit"
            }

            textPixelSize: menuScene.sp(21)
        }
    }

           Image {
                id: highScoreButton
                anchors.horizontalCenter: column.right
                anchors.top: column.bottom
                anchors.topMargin: menuScene.dp(30)
                source: "qrc:/assets/pictures/button_scores_unselected@3x.png"
                MouseArea{
                anchors.fill: parent
                onClicked: {
                    window.state = "gameNetwork"
                    window.gameNetwork.showLeaderboard()
                }
                onPressed: parent.source = "qrc:/assets/pictures/button_scores_selected@3x.png"

                onReleased: parent.source = "qrc:/assets/pictures/button_scores_unselected@3x.png"
                }

            }
           Image {
                id: settingsButton
                anchors.horizontalCenter: column.horizontalCenter
                anchors.top: soundButton.top
                anchors.topMargin: menuScene.dp(20)
                source: "qrc:/assets/pictures/button_settings_unselected@3x.png"
                MouseArea{
                anchors.fill: parent
                
                onClicked: {
                    window.state = "settings"
                }
                
                onPressed: parent.source = "qrc:/assets/pictures/button_settings_selected@3x.png"

                onReleased: parent.source = "qrc:/assets/pictures/button_settings_unselected@3x.png"
                }

            }
           Image {
                id: soundButton
                anchors.horizontalCenter: column.left
                anchors.top: column.bottom
                anchors.topMargin: menuScene.dp(30)
                source: "qrc:/assets/pictures/button_sound off_unselected@3x.png"
                MouseArea{
                anchors.fill: parent
                }

            }


    MediaPlayer {
        id: shoyMusic
        source: "qrc:/assets/sheeran.mp3"
    }
}
