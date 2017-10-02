# allows to add DEPLOYMENTFOLDERS and links to the V-Play library and QtCreator auto-completion
CONFIG += v-play

qmlFolder.source = qml
DEPLOYMENTFOLDERS += qmlFolder # comment for publishing

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# Add more folders to ship with the application here

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the V-Play Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml       android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
    
}

# set application icons for win and macx
win32 {
    RC_FILE += win/app_icon.rc
}
macx {
    ICON = macx/app_icon.icns
}

DISTFILES += \
    qml/scenes/GameScene.qml \
    assets/pictures/Bricks.jpg \
    assets/pictures/BrickPlatform.png \
    assets/pictures/SpringItem.png \
    assets/pictures/WoodenPlatform.png \
    qml/controls/buttons/DefaultButton.qml \
    qml/controls/buttons/BackButton.qml \
    qml/scenes/SettingsScene.qml \
    qml/scenes/MenuScene.qml \
    qml/scenes/CreditsScene.qml \
    assets/pictures/background.jpg \
    assets/pictures/deny.png \
    assets/pictures/back_button.png \
    assets/pictures/accept.png \
    assets/pictures/vplay-logo.png \
    qml/SHOY.qml \
    qml/controls/buttons/DefaultButton.qml \
    qml/scenes/MenuScene.qml \
    assets/shapeOfYou.mp3 \
    qml/objects/WoodenPlatform.qml \
    qml/scenes/AskScene.qml \
    qml/scenes/BaseScene.qml \
    qml/controls/buttons/ScoreBar.qml \
    qml/scenes/GameOverScene.qml \
    qml/objects/static/SlopeLeftFacing.qml \
    qml/objects/interactive/Labirynth.qml \
    qml/objects/HoleItem.qml \
    qml/objects/MovableShelf.qml \
    qml/objects/static/SlopeRightFacing.qml \
    qml/objects/hero/HeroBase.qml \
    qml/objects/hero/Hero.qml \
    qml/objects/hero/ShoyEnergy.qml \
    qml/controls/buttons/ChangeHeroButton.qml \
    qml/controls/buttons/CircleButton.qml \
    qml/controls/buttons/PauseButton.qml \
    qml/controls/buttons/SquareButton.qml \
    qml/controls/buttons/TriangleButton.qml \
    qml/objects/interactive/Spring.qml \
    qml/ScalableImageObject.qml \
    qml/objects/interactive/Spring.qml \
    qml/objects/TrapDoor.qml \
    qml/objects/TopBorder \
    qml/objects/TopBorder.qml \
    qml/scenes/LevelCompletedScene.qml \
    qml/objects/Wall.qml \
    qml/objects/hero/Ghost.qml \
    qml/scenes/PlayGameScene.qml \
    qml/scenes/MultiplayerLobbyScene.qml \
    qml/MultiPlayerLogic.qml \
    qml/controls/buttons/SaveButton.qml \
    qml/scenes/ChooseLevelScene.qml \
    qml/controls/ShoyLevelSelectionList.qml \
    qml/objects/SolidPlatformVaringSize.qml \
    qml/objects/interactive/Stone.qml \
    qml/objects/interactive/Bumper.qml \
    qml/objects/VictoryPlatform.qml \
    qml/objects/Lift.qml \

RESOURCES += \
    resources.qrc

HEADERS += \
    gametimer.h

