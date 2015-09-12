import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.4

import QtQuick.Layouts 1.2

import "Settings"

Window {
    id: settingsWindow
    width: 300
    height: 400

    title: "Overlord - Settings"

    visible: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5

        TabView {
            id: tabView
            Layout.fillHeight: true
            Layout.fillWidth: true

            Tab {
                title: "Twitch"
                TwitchSettings {

                }
            }

            Tab {
                title: "Other"

            }
        }

        RowLayout {
            anchors.bottom: parent.bottom
            Layout.fillWidth: true

            Button {
                text: "Apply"
                onClicked: {
                    tabView.getTab(tabView.currentIndex).children[0].apply()
                }
            }

            Button {
                text: "Cancel"
                onClicked: {
                    tabView.getTab(tabView.currentIndex).children[0].cancel()
                    settingsWindow.visible = false
                }
            }
        }
    }
}

