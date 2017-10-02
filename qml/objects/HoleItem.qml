import VPlay 2.0
import QtQuick 2.0
import "../scenes"

/*
 * This is HoleItem object definition. It defines an abstract
 * hole item which has not visible representation. It serves
 * only as a structure which holds information about hole in
 * the platform.
 */

Item {
    id: holeItem
    x:10
    y:20
    width:100

    // Block position of the hole from being out of the scope
    onXChanged: {
        if(x < 0)
            x = 0;
        else if(x > gameScene.width - width)
            x = gameScene.width - width
    }
}
