/* This is the base scene. All other scenes inherits from that scene.
 * Here we declare basic things like width, height, visible etc.
 */

import VPlay 2.0
import QtQuick 2.0

Scene {
    id: baseScene

    // Signal which will be emmited after back button was pressed
    signal goBackButtonPressed
    property alias backgroundImage: backgroundImage.source

    width: 1080
    height: 1920
    // by default, set the opacity to 0 - this is changed from the main.qml with PropertyChanges
    opacity: 0
    // we set the visible property to false if opacity is 0 because the renderer skips invisible items, this is an performance improvement
    visible: opacity > 0
    // if the scene is invisible, we disable it. In Qt 5, components are also enabled if they are invisible. This means any MouseArea in the Scene would still be active even we hide the Scene, since we do not want this to happen, we disable the Scene (and therefore also its children) if it is hidden
    enabled: visible

    // every change in opacity will be done with an animation
    Behavior on opacity {
        NumberAnimation {
            property: "opacity"
            easing.type: Easing.InOutQuad
        }
    }

    // background
    BackgroundImage {
        id: backgroundImage
        scale: 1.1
        anchors.centerIn: parent
        source: "qrc:/assets/pictures/background@3x.png"
    }
}
