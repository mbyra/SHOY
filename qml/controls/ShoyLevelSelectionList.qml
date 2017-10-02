/*It is a list which allows player to choose levels stored in game.
  */
import QtQuick 2.0
import VPlay 2.0
import "../controls/buttons"

Flickable {
    id: levelSelectionList

    // connect the listModel property to e.g. LevelEditor::applicationQMLLevels
    property alias levelMetaDataArray: levelListRepeater.model

    property alias levelColumn: col

    signal levelSelected(variant levelData)
    signal levelRemoved(variant levelData)
    signal levelEdited(variant levelData)

    //It is a delegate consisting of three buttons and text area.
    //Buttons emits signals which cause level to load, be edited or be removed
    property Component levelItemDelegate: Component {
        Item {
            id: levelItemDelegate
            width:gameScene.width
            height:background.height


            Image {
                id:background
                anchors.centerIn: parent
                source: "qrc:/assets/pictures/background_my levels@3x.png"

            }

                Text{
                    text: modelData.levelName
                    anchors.left: parent.left
                    anchors.leftMargin: menuScene.dp(15)
                    font.pixelSize: menuScene.sp(17)
                    anchors.verticalCenter: parent.verticalCenter

                }
                Item{
                    id:editLevelButton
                    height: background.height
                    width:height
                    visible:  chooseLevelScene.state === "user"
                    anchors.right: removeLevelButton.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: levelEdited(modelData)
                        onPressed: editLevelImage.source = "qrc:/assets/pictures/icon_edit_selected@3x.png"

                        onReleased: editLevelImage.source = "qrc:/assets/pictures/icon_edit_unselected@3x.png"

                    }
                    Image {
                        anchors.centerIn: parent
                        id: editLevelImage
                        //scale: 0.9
                        source: "qrc:/assets/pictures/icon_edit_unselected@3x.png"
                    }
                }
                Item{
                    id:removeLevelButton
                    height: background.height
                    width:height
                    visible:  chooseLevelScene.state === "user"
                    anchors.right: selectLevelButton.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked:levelRemoved(modelData)
                        onPressed: removeLevelImage.source = "qrc:/assets/pictures/icon_delete_selected@3x.png"

                        onReleased: removeLevelImage.source = "qrc:/assets/pictures/icon_delete_unselected@3x.png"

                    }
                    Image {
                        anchors.centerIn: parent
                        id: removeLevelImage
                        //scale: 0.9
                        source: "qrc:/assets/pictures/icon_delete_unselected@3x.png"
                    }
                }
                Item{
                    id:selectLevelButton
                    height: background.height
                    width:height
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: levelSelected(modelData)
                        onPressed: selectLevelImage.source = "qrc:/assets/pictures/icon_levels_right_selected@3x.png"

                        onReleased: selectLevelImage.source = "qrc:/assets/pictures/icon_levels_right_unselected@3x.png"

                    }
                    Image {
                        anchors.centerIn: parent
                        id: selectLevelImage
                        //scale:0.95
                        source: "qrc:/assets/pictures/icon_levels_right_unselected@3x.png"
                    }
                }

            }
        }

    width: col.width
    // use the smaller value as default height, either col.height (when there are few elements) or parent.height
    height: (col.height < parent.height) ? col.height : parent.height
    contentWidth: col.width
    contentHeight: col.height
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.DragAndOvershootBounds
    clip: true

    Column {
        id: col
        spacing: menuScene.dp(5)

        Repeater {
            id: levelListRepeater

            // delegate is the default property of Repeater
            delegate: levelItemDelegate
        } // end of Repeater
    } // end of Column
} // end of Flickable
