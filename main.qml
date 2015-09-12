import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5
import Qt.labs.settings 1.0

import QtWebKit 3.0

ApplicationWindow {
    id: app
    visible: true
    title: qsTr("Overlord")

    property real baseWidth: 1920
    property real baseHeight: 1080

    property font defaultFont;

    defaultFont {
        family: "Calibri"
        pixelSize: 30
        bold: true
    }

    property alias twitchApi: twitchLogin.twitchApi

    property Settings twitchSettings: Settings {
        category: "Twitch"
        property string channel;
        onChannelChanged: {
            console.log("XX_New Channel:", channel)
        }
    }

    Twitch {
        id: twitchLogin
        channel: twitchSettings.channel
    }

    flags: Qt.FramelessWindowHint
    color: "transparent"

    width: app.baseWidth
    height: app.baseHeight + 20


    property real scaleFactor: width / baseWidth

    //toolBar: Toolbar { }

    /* Toolbar {

    }*/

    property Database database : Database { }

    onClosing: {
        Qt.quit();
    }

    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        /*imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
            }
        }*/
    }

    Item {
        id: content

        width: app.baseWidth
        height: app.baseHeight

        transform: Scale {
            xScale: app.scaleFactor
            yScale: app.scaleFactor
        }

        Content {
            anchors.fill: parent
        }
    }

    SettingsWindow {
        id: settingsWindow
    }

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem {
                text: "Quit"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: "Edit"
            MenuItem {
                text: "Settings"

                shortcut: "Ctrl+,"

                onTriggered: {
                    settingsWindow.visible = true
                    settingsWindow.raise();
                }
            }
        }

        Menu {
            title: "Twitch"
            MenuItem {
                text: "Login"
            }
        }
    }


}


