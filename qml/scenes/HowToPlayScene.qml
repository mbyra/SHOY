/* This is the scene which displays instructions and tips how to play the game. */

import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"
import "../"

BaseScene {
    id: highscoresScene

    BackButton {
        id: goBack

        anchors.margins: 10

        MouseArea {
            anchors.fill: parent
            onClicked: window.state = "menu"
        }
    }
}
