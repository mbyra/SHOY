#include <QApplication>
#include <VPApplication>
#include "gametimer.h"
#include <QQmlApplicationEngine>

/*
 * This is starting point for SHOY application
 */

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    VPApplication vplay;

    QQmlApplicationEngine engine;
    vplay.initialize(&engine);

    qmlRegisterType<GameTimer>("shoy.utils.timer", 1, 0, "GameTimer");

    vplay.setMainQmlFileName(QStringLiteral("qml/SHOY.qml"));
    engine.load(QUrl(vplay.mainQmlFileName()));

    return app.exec();
}
