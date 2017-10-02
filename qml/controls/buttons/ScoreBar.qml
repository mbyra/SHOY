/* This is our scorebar, which show our result from the game. It is shown on the top of the scene.
*/

import QtQuick 2.7
import VPlay 2.0

Item{
    property int score: 0
    width: image.width
    height: image.height
    anchors {
        top: parent.top
        topMargin: menuScene.dp(9)
    }

    Image{
        id:image
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/score_background@3x.png"

    }
    Text{
        id:text
        anchors.fill: parent
        text: parent.score
        font.pointSize: gameScene.dp(25)
        font.family: shoyFont.name
        color: "black"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
