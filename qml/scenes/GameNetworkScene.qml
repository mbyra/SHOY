/* These scene shows player profile and his/her highscore. He/she can also see other players scores.
*/


import QtQuick 2.0
import VPlay 2.0
import "../"

BaseScene {
    id: gameNetworkScene
    width: 320
    height: 480

    property alias gameNetworkView: gameNetworkView

    VPlayGameNetworkView {
        id: gameNetworkView

        anchors.fill: gameNetworkScene.gameWindowAnchorItem

        onBackClicked: {
            window.state = "menu"
        }
    }
}
