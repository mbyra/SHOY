/* Credit scene is used to display informations abour developers
 */


import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"

BaseScene {



    BackButton {
        id: goBack

        anchors.margins: 10

        MouseArea {
            anchors.fill: parent
            onClicked: window.state = "menu"
        }
    }
}
