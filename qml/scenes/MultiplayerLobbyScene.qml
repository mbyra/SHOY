/*
  This scene contains VPlayMultiplayerView, which is used for view lobby scene, friends scene
  and other scenes important for multiplayer.
  */

import QtQuick 2.0
import VPlay 2.0
import "../"

BaseScene {
    id: multiplayerLobbyScene

    property alias multiplayerView: myMultiplayerView //to find it in shoy.qml

    width: 320
    height: 480

    // This component give us view for lobby, inviting friends and other important thing for multiplayer
    VPlayMultiplayerView{
        id: myMultiplayerView
        onBackClicked: window.state = "menu"
    }
}
