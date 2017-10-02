/*
 * This is a Labirynth object file. It is an object, which
 * allow player to turn the gravitation upside down.
 * The difficulty is that he has to find appropriate way out of Labirynth
 * IMPORTANT NOTE the object won't work if you won't assing signal inverseGravity
 * to apropriate script in GameScene
 */
import QtQuick 2.2
import VPlay 2.0
import "../hero"
import "../../scenes"
import "../"

EntityBaseDraggable {
    id: labirynth
    entityType: "Labirynth"

    //levelEditor properties
    selectionMouseArea.anchors.fill: labirynthCollider
    inLevelEditingMode: window.state === "levelEditor"

    // since our levels have no size limit, we don't want any
    // boundaries when dragging our entities
    ignoreBounds: true
    dragOffset: Qt.point(-width/2,-70)

    onEntityPressAndHold: popUp.visible ^= true
    selectionMouseArea.onClicked:if(popUp.visible === true) popUp.visible = false
    //Pop up which allows editing of the object
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
                maximumValue: gameScene.height
                onValueChanged: labirynth.height = value

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
                onClicked: labirynth.removeEntity()

                anchors.verticalCenter: parent.verticalCenter
            }
            }
        }
    }

    width: gameScene.width // visual width of the platform
    height: window.baseSceneHeight / 3 // visual height of the platform

    onStateChanged: {
        inverseGravity()
    }
    //This is a collider which serves as a detector that player entered
    //labirynth. After detection it allows player to inverse gravity
    Rectangle{
        anchors.fill: labirynthCollider
        gradient:  Gradient {
            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 1.0; color: "blue" }
        }
        border.width: 1
        border.color: inLevelEditingMode? "black":"transparent"
    }

    BoxCollider {
        id:labirynthCollider
        anchors.fill: parent
        bodyType: Body.Static
        collisionTestingOnlyMode: true//sensor: true

        fixture.onEndContact: {
            var otherEntity = other.getBody().target
            if (otherEntity.entityType === "Hero") {
                // Update hero's score if platform passed
                if(otherEntity.y < labirynth.y &&
                        labirynth.y < otherEntity.platformLevelHight){
                    otherEntity.setPlatformLevelHight(labirynth.y);
                    otherEntity.updateScore(50);
                }
            }
        }
    }


    states: [
        State {
            name: "regularGravity"
        },
        State {
            name: "inversedGravity"
        }
    ]
}
