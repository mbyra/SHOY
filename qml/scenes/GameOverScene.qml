/*This is gameOverScene which is displayed after death of the player
 */
import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"
BaseScene {


    Image{
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/pop up_game over@3x.png"
        Image{
            anchors.centerIn: parent
            source: "qrc:/assets/pictures/game over_text@3x.png"
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            window.gameNetwork.reportScore(window.score)
            window.state = "menu"
        }
    }
}
