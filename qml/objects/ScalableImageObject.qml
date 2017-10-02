/*
 *ScalableImageObject is an smart image which allows
 *image to scale not significantly in width when the length of the object
 *increases. This way the length of middle image is not scaled
 *only the side images.
 */
import QtQuick 2.0

Item {
    id: scalableImage
    height: imageHeight
    property real imageHeight
    property string leftSource: "qrc:/assets/pictures/brickwall_left@3x.png"
    property string middleSource: "qrc:/assets/pictures/brickwall_middle@3x.png"
    property string rightSource: "qrc:/assets/pictures/brickwall_right@3x.png"
    property real sideImageWidth: 57.33
    property real middleImageWidth: 113.66
    property real sideWidth: (width - Math.floor(
                                  width / gameScene.width * 8) * middleImageWidth) / 2

    Row {
        //Row should not be visible if the width of platform is shorter
        //than left image and middle image width
        visible: !(parent.x < gameScene.width / 2 && Math.floor(
                       scalableImage.width / gameScene.width * 8) == 0)
        Image {
            id: left
            width: scalableImage.sideWidth
            source: scalableImage.leftSource
            height: scalableImage.imageHeight
        }
        // middle part is repeated as long as the width of
        //ScalableImageObject is not filled
        Repeater {
            id: middleSegmentRepeater
            model: Math.floor(scalableImage.width / gameScene.width * 8)
            Image {
                source: scalableImage.middleSource
                height: scalableImage.imageHeight
            }
        }
        Image {
            id: right
            source: scalableImage.rightSource
            height: scalableImage.imageHeight
            width: scalableImage.sideWidth
        }
    }

    //image should be displayed only if the width of platform is shorter
    //than left image and middle image width
    Image {
        id: backup
        source: scalableImage.rightSource
        anchors.fill: parent
        visible: parent.x < gameScene.width / 2 && Math.floor(
                     scalableImage.width / gameScene.width * 8) == 0
    }
}
