/*This is gameOverScene which is displayed after death of the player
 */
import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"
import "../"

BaseScene {
    id: levelCompletedScene

    Image{
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/pop up_game over@3x.png"
        Image {
            id: textImageCongrats
            anchors.centerIn: parent
            scale: 0.5
            source: "qrc:/assets/pictures/good_job_text.png"
        }

        Text {
            anchors.top: textImageCongrats.bottom
            anchors.topMargin: textImageCongrats.height / 3
            anchors.horizontalCenter: parent.horizontalCenter
            text: 'Level completed!'
            font.pixelSize: levelCompletedScene.dp(20)
            font.family: shoyFont.name
            color: "white"
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
