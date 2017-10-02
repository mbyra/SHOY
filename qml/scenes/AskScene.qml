/*Scene which is shown when users wants to exit from some part of the game.
 *For example from menu out of app or from gameplay to menu.
 */
import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"

BaseScene {
    id: askScene

    property alias acceptMouseArea: acceptItem.mouseArea
    property alias denyMouseArea: denyItem.mouseArea
    property alias question: textArea.question
 //   property alias background: backgroundImg.source


        Image{
            id:textArea

            property alias question: questionText.text

            anchors.centerIn: parent
            source: "qrc:/assets/pictures/pop up_leave@3x.png"
            Text {
                id: questionText
                font.family: shoyFont.name
                anchors.fill: parent
                anchors.margins: askScene.dp(20)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font{pixelSize: askScene.dp(20); bold: false}
                color:"white"
            }



    }

    // Button which should serve as a cancel anserw to question asked in text area.
    Item {
        id: acceptItem
        property alias mouseArea: acceptMouseArea
        width: denyImage.width
        height: denyImage.height
        Image {
            id:acceptImage
            anchors.centerIn: parent
            source: "qrc:/assets/pictures/button_leave@3x.png"
        }

        anchors.top: textArea.bottom
        anchors.right: textArea.horizontalCenter
        anchors.margins: menuScene.dp(5)
        MouseArea {
            id: acceptMouseArea
            anchors.fill: parent
        }
    }

    // Button which should serve as a cancel anserw to question asked in text area.
    Item {
        id: denyItem
        property alias mouseArea: denyMouseArea
        Image {
            id:denyImage
            anchors.centerIn: parent
            source: "qrc:/assets/pictures/button_cancel@3x.png"
        }

        width: denyImage.width
        height: denyImage.height
        anchors.top: textArea.bottom
        anchors.left: textArea.horizontalCenter
        anchors.margins: menuScene.dp(5)
        MouseArea {
            id: denyMouseArea
            anchors.fill: parent
        }
    }
}
