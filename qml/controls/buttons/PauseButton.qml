/* This button is used to pause the game.
  */

import QtQuick 2.7
import QtQuick.Controls 2.1
import VPlay 2.0


ButtonVPlay {
    width:image.width
    height:image.height
    anchors {
        top: parent.top
        left: parent.left
        topMargin: menuScene.dp(9)
        leftMargin: menuScene.dp(12)
    }
    Image {
        id:image
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/button_pause_normal@3x.png"
    }

}
