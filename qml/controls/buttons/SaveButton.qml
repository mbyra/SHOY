import QtQuick 2.0
import VPlay 2.0

ButtonVPlay {

    width:parent.width/10
    height:width
    Rectangle {
        color: "white"
        anchors.fill: parent
    }

    Image {
        anchors.fill: parent
        source: "qrc:/assets/pictures/save-icon.png"
    }

    // this text signals, that the level has been saved
    Text {
      // text and text color
      text: "saved"
      color: "#ffffff"
      font.pixelSize: gameScene.dp(20)
      font.family: shoyFont.name

      // by default this text is opaque/invisible
      opacity: 0

      // anchor to the bottom of the save button
      anchors.top: saveButton.bottom
      anchors.horizontalCenter: saveButton.horizontalCenter

      // outline the text, to increase it's visibility
      style: Text.Outline
      styleColor: "#009900"

      // this animation shows and slowly fades out the save text
      NumberAnimation on opacity {
        id: savedTextAnimation

        // slowly reduce opacity from 1 to 0
        from: 1
        to: 0

        // duration of the animation, in ms
        duration: 2000
      }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            nativeUtils.displayTextInput("Enter level name", "Enter a level name. (3-15 characters)", "", levelEditor.currentLevelName)
        }
    }

    // this listens for the end of the native text input dialog
    Connections {
      target: nativeUtils

      onTextInputFinished: {
        // if the text input dialog is closed
        // and the user clicked "ok"
        if(accepted) {

          // the text can't be longer than 9 characters
          if(enteredText.length > 15) {
            nativeUtils.displayMessageBox("Invalid level name", "A maximum of 15 characters is allowed!")
            return
          }
          else if (enteredText.length < 3) {
              nativeUtils.displayMessageBox("Invalid level name", "A minimum of 3 characters is needed!")
              return
          }

          // change level name
          levelEditor.currentLevelName = enteredText
          gameScene.saveLevel()
          savedTextAnimation.restart()
        }
      }
    }

}


