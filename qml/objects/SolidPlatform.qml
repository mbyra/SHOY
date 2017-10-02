/*
 * This is a SolidPlatform object file. It defines
 * a special platform which cannot be passed by the player
 * from the bottom of it. SolidPlatform can be passed
 * only using a hole in the platform. SolidPlatform is
 * item which can be useful for the player to move around
 * on it, or as a obstacle which has to be passed to climb
 * up the tower.
*/
import QtQuick 2.2
import VPlay 2.0
import "../scenes"

EntityBaseDraggable {
    id: solidPlatform
    width: gameScene.width // visual width of the platform
    height: gameScene.width/ 16 // visual height of the platform
    entityType: "SolidPlatform"

    //levelEditor properties
    selectionMouseArea.anchors.fill: solidPlatform
    inLevelEditingMode: window.state === "levelEditor"
    // if the obstacle was pressed and held, remove it
    onEntityPressAndHold: removeEntity()
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)
    //itemEditor


    // Holes counter
    property int holeCount: 0
    // Container for the holes defined with the platform object
    property list<HoleItem> holeList
    // Array which holds holes/solid start/end points
    property var keyCoordinates: [0, 0, 0, 0, 0, 0, 0, 0]
    // Array which holds start-end pairs of the solids of the platform.
    // Coordinates at even positions are start of the solids, at odd positions
    // are end of the solids.
    property var solidsCoordinates: [0, 0, 0, 0, 0, 0, 0, 0]
    // Makes it impossible for player to be in walking state:
    property bool inLabirynth: false

    // Function fills up solidsCoordinates table and returns
    // number of solids to be created
    function findSolids() {
        computeKeyCoordinates()
        var currIdx = 0
        for (var i = 0; i <= holeCount; ++i) {
            if (keyCoordinates[2 * i] !== keyCoordinates[2 * i + 1]) {
                solidsCoordinates[currIdx++] = keyCoordinates[2 * i]
                solidsCoordinates[currIdx++] = keyCoordinates[2 * i + 1]
            }
        }
        //computeSolidWidths()
        return currIdx / 2
    }

    // Function which fills up keyCoordinates array,
    // which is used to get the number of visible solids
    function computeKeyCoordinates() {
        keyCoordinates[0] = 0
        var currIdx = 0
        for (var i = 0; i < holeCount; ++i) {
            keyCoordinates[++currIdx] = holeList[i].x
            keyCoordinates[++currIdx] = holeList[i].x + holeList[i].width
        }
        keyCoordinates[2 * holeCount + 1] = width
    }

    Repeater {
        id: spritesRepeater
        model: solidPlatform.findSolids()
        ScalableImageObject {
            x: solidsCoordinates[2 * index] // get next even number - start
            imageHeight: solidPlatform.height
            width: solidsCoordinates[2 * index + 1] - x //width = end - start
            leftSource: "qrc:/assets/pictures/brickwall_left@3x.png"
            rightSource: "qrc:/assets/pictures/brickwall_right@3x.png"
            middleSource: "qrc:/assets/pictures/brickwall_middle@3x.png"
        }
    }

    // Create solid's box colliders
    Repeater {
        model: solidPlatform.findSolids()
        // BoxCollider responsible for collision detection
        BoxCollider {
            x: solidsCoordinates[2 * index] // get next even number - start
            width: solidsCoordinates[2 * index + 1] - x //width = end - start
            height: gameScene.width / 16
            bodyType: Body.Static
            fixture.onBeginContact: {
                var otherEntity = other.getBody().target
                if (otherEntity.entityType === "Hero" && !inLabirynth) {
                    // Increase the number of active contacts the player has
                    hero.contacts++
                }
            }
            fixture.onEndContact: {
                var otherEntity = other.getBody().target
                if (otherEntity.entityType === "Hero" && !inLabirynth) {
                    // If the player leaves a platform, we decrease its number of active contacts
                    hero.contacts--
                }
            }
            // Response to contact with another object
            fixture.onContactChanged: {
                var otherEntity = other.getBody().target // get hit entity
                var otherEntityType = otherEntity.entityType // get hit entity type
                // Activities related to collision with hero
                if (otherEntityType === "Hero") {
                    // Update hero's score if platform passed
                    if (solidPlatform.y < otherEntity.platformLevelHight
                            && solidPlatform.y - otherEntity.height >= otherEntity.y) {
                        otherEntity.setPlatformLevelHight(solidPlatform.y)
                        otherEntity.updateScore(20)
                    }
                }
            }
        }
    }
//    EditableComponent {
//        editableType: "SolidPlatform"
//        targetEditor: gameScene.itemEditor
//        properties: {
//            "Bounds": {
//            "width": {
//                "min": 0,
//                     "max": parent.width
//            }
//            }
//        }
//    }

}
