/*
 * This is definition of the shoy energy.
 * It loads our sprite and set up all properties.
 * This sprite is inside our hero
 */

import QtQuick 2.0
import VPlay 2.0

AnimatedSpriteVPlay {
    id: sprite
    width: parent.width
    height: parent.height
    source: "qrc:/assets/pictures/SHOYsprite2.png"
    frameCount: 24
    frameRate: 20
    frameWidth: 100
    frameHeight: 100
    loops: Animation.Infinite

    //this is trigger - it runs when its visible
    onVisibleChanged: {
        if(parent.visible === true)
            restart()
    }
}
