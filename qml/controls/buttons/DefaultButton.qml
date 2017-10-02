/* This button is the base for all menu buttons in our game.
*/

import QtQuick 2.7
import VPlay 2.0

Item {
    id: button

    // the horizontal margin from the Text element to the Rectangle at both the left and the right side.
    property int paddingHorizontal: 10
    // the vertical margin from the Text element to the Rectangle at both the top and the bottom side.
    property int paddingVertical: 5

    property string defaultColor: "green"
    property string hoverColor: "blue"
    property alias text: buttonText.text
    property int textLength: buttonText.contentWidth
    property int textHeight: buttonText.contentHeight
    // property alias opacity: background.opacity
    //property alias radius: background.radius

    property alias textPixelSize: buttonText.font.pixelSize

    // public events
    signal clicked    

    // this will be the default size, it is same size as the contained text + some padding
    width: background.width//buttonText.width + paddingHorizontal * 5
    height: background.height//buttonText.height + paddingVertical * 2

    // button background
    Image {
        id: background
        //color: mouseArea.containsMouse ? hoverColor : defaultColor
        source:"qrc:/assets/pictures/mainscreen_textbackground@3x.png"
        anchors.centerIn: parent
        //radius: 80
    }

    // button text
    Text {
        id: buttonText
        anchors.centerIn: background
        font.bold: true
//        font.pixelSize: 75
        color: "white"
        font.family: shoyFont.name
    }

    // mouse area to handle click events
    MouseArea {
        id: mouseArea
        anchors.fill: background
        hoverEnabled: true

        onClicked: button.clicked()
    }
}
