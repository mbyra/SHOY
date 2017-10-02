/* This is a button which serves, as a subcomponent to ChangeHeroButton.
 */
import QtQuick 2.0
import VPlay 2.0


Item {
    id: circle

    signal clicked

    Image {
        id: circlelImage
        anchors.fill: parent
        source: "qrc:/assets/pictures/button_change_circle_side@3x.png"
    }
    MouseArea{
        id:mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
