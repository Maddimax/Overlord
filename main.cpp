#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QSurfaceFormat>
#include <QDebug>
#include <QQuickWindow>

#include <QRunnable>
#include <QOpenGLFunctions>

#ifdef _WIN32
#include <windows.h>
#endif

#include "TwitchApi/twitchapi.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("Mad");
    app.setApplicationName("Overlord");

//    QQuickWindow::setDefaultAlphaBuffer(true);

    qmlRegisterType<TwitchApi>("com.overlord.twitchapi", 1, 0, "TwitchApi");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

#if _WIN32
    QQuickWindow* quickWindow = quickWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().at(0));

    if(quickWindow)
    {
        int windowStyle = GetWindowLong((HWND)quickWindow->winId(), GWL_EXSTYLE);
        SetWindowLong((HWND)quickWindow->winId(), GWL_EXSTYLE, windowStyle & WS_EX_APPWINDOW);
    }
#endif


    return app.exec();
}

