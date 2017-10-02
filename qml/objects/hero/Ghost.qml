/*
  This is a ghost object. It's a shadow of other player, when we play in multiplayer mode.
  It shows the position of other player, so we can see his progress.
  It just load image and we upload in runtime it's x and y. We also upload ghost's shape.
  We don't define colliders here because it will cause a lot's of problems, so moving image is enoght for now.
  */

import QtQuick 2.0
import VPlay 2.0

EntityBase{
    id: ghost
    entityType: "Ghost"

    property string shape: "circle" //this property turn on right shape
    property var playerID //this is to connect ghost to player
    property var score: 0

    //this function is for updating x and y
    function updatePosition(newX, newY)
    {
        x = newX
        y = newY
    }

    //here we update score of other player
    function updateScore(newScore)
    {
        score = newScore
    }

    opacity: 0.5 // we want to give some opacity to our ghost, this make him different from hero.
    height: gameScene.height/16
    width: height

    //here we change the shape of our ghost
    onShapeChanged: ghostBody.state = shape

    //Here we define body of ghost
    Image{
        id:ghostBody
        state: "circle"

        //ShoyEnergy in our shape
        ShoyEnergy {
            id: shoyEnergy
        }

        //Here we declare states of our image - when state change, we load right image and we change some properties
        states: [
            State{
                name: "circle"
                PropertyChanges {
                    target: ghostBody
                    anchors.fill: ghost
                    source: "qrc:/assets/pictures/mainshape_circle@3x.png"
                }

                PropertyChanges {
                    target: shoyEnergy
                    anchors.centerIn: ghostBody
                }
            },

            State{
                name: "square"
                PropertyChanges {
                    target: ghostBody
                    anchors.fill: ghost
                    source: "qrc:/assets/pictures/maineshape_square@3x.png"
                }

                PropertyChanges {
                    target: shoyEnergy
                    anchors.centerIn: ghostBody
                }
            },

            State{
                name: "triangle"
                PropertyChanges {
                    target: ghostBody
                    width: ghost.width
                    height: ghost.height * 0.866
                    source: "qrc:/assets/pictures/mainshape_triangle@3x.png"
                }

                PropertyChanges {
                    target: shoyEnergy
                    width: ghostBody.width / 2
                    height: ghostBody.height / 2
                    anchors.bottomMargin: ghostBody.height / 10
                    anchors.bottom: ghostBody.bottom
                    anchors.horizontalCenter: ghostBody.horizontalCenter
                }
            }
        ]
    }
}
