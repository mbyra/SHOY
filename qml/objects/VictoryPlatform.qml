/*
 * This is a WoodenPlatform object file. It defines
 * a special platform which can be passed by the player
 * from the bottom of it. Platform has its own collider
 * which allows player to stand on it. It is static
 * board item and only helps the player to move around
 * the board.
 */
import QtQuick 2.2
import VPlay 2.0
import "../scenes"
import "../"

EntityBaseDraggable {
    id: victoryPlatform
    entityType: "VictoryPlatform"
    //levelEditor properties
    colliderComponent: platformCollider
    selectionMouseArea.anchors.fill: image
    inLevelEditingMode: window.state === "levelEditor"
    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width / 2, -70)

    width: gameScene.width - 4 * gameScene.wallWidth // visual width of the platform
    height: gameScene.width / 16 // visual height of the platform

    toStoreProperties: ["width"]
    // Platform image
    Image {
        id: image
        source: "qrc:/assets/pictures/shape_13@3x.png"
        anchors.fill: parent
    }
    onEntityPressAndHold: popUp.visible ^= true
    selectionMouseArea.onClicked:if(popUp.visible === true) popUp.visible = false
    Item {
        id: popUp
        visible: false

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
                maximumValue: gameScene.width - 4 * gameScene.wallWidth
                onValueChanged: woodenPlatform.width = value

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
                onClicked: woodenPlatform.removeEntity()

                anchors.verticalCenter: parent.verticalCenter
            }
            }
        }
    }

    // BoxCollider responsible for collision detection
    BoxCollider {
        id: platformCollider
        width: parent.width // actual width is the same as the parent entity
        height: parent.height // actual height is the same as the parent entity
        bodyType: Body.Static // only Dynamic bodies can collide with each other

        // Response to contact with another object
        fixture.onContactChanged: {

            var otherEntity = other.getBody().target // get hit entity
            var otherEntityType = otherEntity.entityType // get hit entity type
            // Activities related to collision with hero
            if (otherEntityType === "Hero") {
                // Update hero's score if platform passed
                if (woodenPlatform.y < otherEntity.platformLevelHight
                        && woodenPlatform.y - otherEntity.height >= otherEntity.y) {
                    otherEntity.setPlatformLevelHight(woodenPlatform.y)
                    otherEntity.updateScore(10)
                }
            }
        }
    }

}
