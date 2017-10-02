/*
  This scene is for choosing between single player and multiplayer.
  When we push single player button, we start game.
  When we push multiplayer button, we enter the multiplayer setting.
  */
import VPlay 2.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtMultimedia 5.5
import "../controls/buttons"

BaseScene {
    id: playGameScene

    BackButton {
        id: goBack

        anchors.margins: 10

        MouseArea {
            anchors.fill: parent
            onClicked: window.state = "menu"
        }
    }

    // menu
    Column {
        id: column

        anchors {
            centerIn: parent
            bottomMargin: 20
        }
        spacing: 50

        DefaultButton {
            id:singlePlayerButton
            text: "Single Player"
            onClicked: {
                window.state = "chooseLevel"
                chooseLevelScene.state = "basic"
            }
            width: singlePlayerButton.textLength + paddingHorizontal * 7
            textPixelSize: menuScene.sp(21)
        }
        DefaultButton {
            text: "Multiplayer"
            onClicked: {
                window.state = "multiplayerLobby"
            }
            width: singlePlayerButton.textLength + paddingHorizontal * 7
            textPixelSize: menuScene.sp(21)
        }
    }
}
