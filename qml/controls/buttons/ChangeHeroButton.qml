import QtQuick 2.0
import VPlay 2.0

Item {
    id: changeHeroButton

    //Aliases are used to set all three loaders sources in one state definition.
    property alias leftLoaderAlias: leftLoader
    property alias rightLoaderAlias: rightLoader
    property alias centralLoaderAlias: centralLoader

    //These signals are used to change hero's shape
    signal morphToCircle
    signal morphToSquare
    signal morphToTriangle

    onMorphToCircle: hero.shape = "circle"
    onMorphToSquare: hero.shape = "square"
    onMorphToTriangle: hero.shape = "triangle"

    anchors{bottom: parent.bottom ;bottomMargin: 30 ;horizontalCenter: parent.horizontalCenter}
    width: parent.width / 3
    height: parent.height / 10
    state: "circle"

    Image {
        id: background
        anchors.centerIn:  parent
        scale: 0.7
        source: "qrc:/assets/pictures/button_change_object_empty@3x.png"
    }
    Component {
        id: circleButtonComponent
        CircleButton {
            id: circleButton
            onClicked: {
                morphToCircle()
                changeHeroButton.state = "circle"
            }
        }
    }

    Component {
        id: squareButtonComponent
        SquareButton {
            id: squareButton
            onClicked: {
                morphToSquare()
                changeHeroButton.state = "square"
            }
        }
    }

    Component {
        id: triangleButtonComponent
        TriangleButton {
            id: triangleButton
            onClicked: {
                morphToTriangle()
                changeHeroButton.state = "triangle"
            }
        }
    }

    Loader {
        id: leftLoader
        opacity: 1
        anchors{verticalCenter: parent.verticalCenter; left: parent.left; margins: 5}
        width: parent.width / 4
        height: width
    }
    Loader {
        id: rightLoader
        opacity: 1
        anchors{verticalCenter: parent.verticalCenter; right: parent.right; margins: 5}
        width: parent.width / 4
        height: width
    }
    Loader {
        id: centralLoader
        opacity: 1
        anchors.centerIn: parent
        width: parent.width / 3
        height: width
    }

    states: [
        State {
            name: "circle"
            PropertyChanges {
                target: changeHeroButton
                centralLoaderAlias.sourceComponent: circleButtonComponent
                leftLoaderAlias.sourceComponent: squareButtonComponent
                rightLoaderAlias.sourceComponent: triangleButtonComponent
            }
        },
        State {
            name: "triangle"
            PropertyChanges {
                target: changeHeroButton
                centralLoaderAlias.sourceComponent: triangleButtonComponent
                leftLoaderAlias.sourceComponent: squareButtonComponent
                rightLoaderAlias.sourceComponent: circleButtonComponent
            }
        },
        State {
            name: "square"
            PropertyChanges {
                target: changeHeroButton
                centralLoaderAlias.sourceComponent: squareButtonComponent
                leftLoaderAlias.sourceComponent: triangleButtonComponent
                rightLoaderAlias.sourceComponent: circleButtonComponent
            }
        }
    ]
}
