/*This is a level selection scene. It allows player to choose, edit or remove level
 *There are currently two types of levels, deployed with the game(basic) and made by user
 */
import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"
import "../controls/"

BaseScene {
    id: chooseLevelScene

    property alias levelSelection: levelSelectionList

    state: "basic"
    states: [
        State {
            // Basic levels, bundled with the game
            name: "user"
            PropertyChanges {
                target: levelSelectionList
                levelMetaDataArray: levelEditor.authorGeneratedLevels
            }
            PropertyChanges {
                target: topBar
                source: "qrc:/assets/pictures/switch_01@3x.png"
            }
        },
        State {
            // Levels created by user with Level Editor
            name: "basic"
            PropertyChanges {
                target: levelSelectionList
                levelMetaDataArray: levelEditor.applicationJSONLevels
            }
            PropertyChanges {
                target: topBar
                source: "qrc:/assets/pictures/switch_02@3x.png"
            }
        },
        State {
            // Levels created by community
            name: "community"
            PropertyChanges {
                target: chooseLevelScene
                levelSelectionListAuthor.visible: false
            }
        }
    ]

    Image {
        id: topBar
        anchors.top: parent.top
        anchors.horizontalCenter: chooseLevelScene.gameWindowAnchorItem.horizontalCenter
        source: "qrc:/assets/pictures/switch_02@3x.png"
        Row {
            anchors.fill: parent

            Item {
                width: topBar.width / 2
                height: topBar.height
                Text {
                    id: createdTextArea
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: qsTr("CREATED")
                    font.pixelSize: chooseLevelScene.sp(16)
                    color: "#ffdfca"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        chooseLevelScene.state = "user"
                        //topBar.source = "qrc:/assets/pictures/switch_01@3x.png"
                    }
                }
            }
            Item {
                width: topBar.width / 2
                height: topBar.height
                Text {
                    id: gameTextArea
                    anchors.fill: parent
                    text: qsTr("GAME")
                    font.pixelSize: chooseLevelScene.sp(16)
                    color: "#ffdfca"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        chooseLevelScene.state = "basic"
                        //topBar.source = "qrc:/assets/pictures/switch_02@3x.png"
                    }
                }
            }
        }
    }

    BackButton {
        id: goBack

        anchors {
            top: topBar.bottom
            right: topBar.right
            topMargin: 10
            rightMargin: 10
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                window.state = "menu"
            }
        }
    }


    ShoyLevelSelectionList {
        id: levelSelectionList
        visible: true
        anchors.horizontalCenter: chooseLevelScene.gameWindowAnchorItem.horizontalCenter
        anchors.top: goBack.bottom
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        anchors.rightMargin: 40
        anchors.leftMargin: 40

        levelItemDelegate: levelItemDelegate

        // this connects the stored levels from the player with the level list
        levelMetaDataArray: levelEditor.applicationJSONLevels

        onLevelRemoved: {
            // load level
            levelEditor.loadSingleLevel(levelData)

            // remove loaded level
            levelEditor.removeCurrentLevel()
        }
        onLevelEdited: {
            levelEditor.loadSingleLevel(levelData)

            // switch to gameScene, play mode
            gameWindow.state = "game"
            gameScene.state = "edit"

            // initialize level
            gameScene.reloadScene()
        }
    }
}
