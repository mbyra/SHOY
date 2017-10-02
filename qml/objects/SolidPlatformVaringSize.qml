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
    id: solidPlatformVaryingSize
    width: gameScene.width // visual width of the platform
    height: gameScene.width/ 16 // visual height of the platform
    entityType: "SolidPlatform"

    //levelEditor properties
    selectionMouseArea.anchors.fill: solidPlatformCollider
    inLevelEditingMode: window.state === "levelEditor"

    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)
    onEntityPressAndHold: popUp.visible ^= true
    selectionMouseArea.onClicked:if(popUp.visible === true) popUp.visible = false
    toStoreProperties: ["width"]

    //Pop up which allows editing of the object
    Item {
        id: popUp
        visible: false
        onFocusChanged: if(focus === false) visible = false
        z: 1
        width: parent.width
        height: parent.height * column.children.length
        anchors.top: parent.bottom
        anchors.topMargin: 20
        x:0
        Column {
            id:column
            anchors.fill: parent
            Row{

                spacing: 10
                Text {
                    text: qsTr("width")
                    font.pixelSize: gameScene.dp(20)
                }
            SliderVPlay {
                id:slider
                minimumValue: 0
                maximumValue: gameScene.width
                onValueChanged: solidPlatformVaryingSize.width = value

                anchors.verticalCenter: parent.verticalCenter
            }
            }
            Row{
                spacing: 10
                Text {
                    text: qsTr("remove")
                    font.pixelSize: gameScene.dp(20)
                }
            ButtonVPlay {
                height:slider.height
                width:slider.width/2
                onClicked: solidPlatformVaryingSize.removeEntity()

                anchors.verticalCenter: parent.verticalCenter
            }
            }
        }
    }

    //Image of the platform
        ScalableImageObject {
            id:woodenPlatformImage
            imageHeight: parent.height
            width: parent.width//width = end - start
            leftSource: "qrc:/assets/pictures/brickwall_left@3x.png"
            rightSource: "qrc:/assets/pictures/brickwall_right@3x.png"
            middleSource: "qrc:/assets/pictures/brickwall_middle@3x.png"
        }


    // Create solid's box colliders

        BoxCollider {
            id:solidPlatformCollider
            width: parent.width //width = end - start
            height: gameScene.width / 16
            bodyType: Body.Static

            // Response to contact with another object
            fixture.onContactChanged: {
                var otherEntity = other.getBody().target // get hit entity
                var otherEntityType = otherEntity.entityType // get hit entity type
                // Activities related to collision with hero
                if (otherEntityType === "Hero") {
                    // Update hero's score if platform passed
                    if (solidPlatformVaryingSize.y < otherEntity.platformLevelHight
                            && solidPlatformVaryingSize.y - otherEntity.height >= otherEntity.y) {
                        otherEntity.setPlatformLevelHight(solidPlatformVaryingSize.y)
                        otherEntity.updateScore(20)
                    }
                }
            }
        }


}
