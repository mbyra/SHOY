/* This scene shows all setting of the game. Here we can turn on or off music, sounds and vibrations.
 * In future there can be more options.
 */


import QtQuick 2.7
import QtQuick.Layouts 1.1
import VPlay 2.0
import "../controls/buttons"

BaseScene {
    id: settingsScene

    BackButton {
        id: goBack

        anchors.margins: settingsScene.dp(10)

        MouseArea {
            anchors.fill: parent
            onClicked: window.state = "menu"
        }
    }

    //Here we have our setting. We can turn them on or off.
    Column {
        id: columnLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: settingsScene.dp(20)
        spacing: settingsScene.dp(20)

        RowLayout {
            id: musicLayout

            anchors{centerIn: parent.Center
                    right: parent.right
                    rightMargin: settingsScene.dp(10)}
            Layout.alignment: Qt.AlignCenter
            spacing: settingsScene.dp(30)
            Text {
                id: musicText

                font.family: shoyFont.name
                text: "Music: "
                font.bold: true
                font.pixelSize: settingsScene.dp(30)
            }
            SwitchVPlay {
                height: musicText.height
                scale:2
                // onValueChanged: TODO
            }
        }

        RowLayout {
            id: soundLayout

            anchors{centerIn: parent.Center
                    right: parent.right
                    rightMargin: settingsScene.dp(10)}
            Layout.alignment: Qt.AlignCenter
            spacing: settingsScene.dp(30)
            Text {
                id: soundText

                font.family: shoyFont.name
                text: "Sound: "
                font.bold: true
                font.pixelSize: settingsScene.dp(30)
            }
            SwitchVPlay {
                height: soundText.height
                scale:2
                // onValueChanged: TODO
            }
        }

        RowLayout {
            id: vibrationsLayout

            anchors{centerIn: parent.Center
                    right: parent.right
                    rightMargin: settingsScene.dp(10)}
            Layout.alignment: Qt.AlignCenter
            spacing: settingsScene.dp(30)
            Text {
                id: vibrationsText

                font.family: shoyFont.name
                text: "Vibrations: "
                font.bold: true
                font.pixelSize: settingsScene.dp(30)
            }
            SwitchVPlay {
                height: vibrationsText.height
                scale: 2
                // onValueChanged: TODO
            }
        }
    }
}
