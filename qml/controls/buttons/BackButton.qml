/*This is a button, which serves as application flow controller.
 *Assign to it a signal, which will allow to get back to previous screen
 */
import QtQuick 2.0

Item {
    anchors {
        top: parent.top
        right: parent.right
        topMargin: menuScene.dp(9)
        rightMargin: menuScene.dp(12)
    }
    width: image.width
    height:  image.height
    Image {
        id:image
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/button_arrow_normal@3x.png"
    }

}
