import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

import Qt.labs.settings 1.0

Item {
    function apply() {
        console.log("Applying ...")
        app.twitchSettings.channel = twitchChannel.text
    }

    function cancel() {
        twitchChannel.text = app.twitchSettings.channel
    }

    ColumnLayout {
        anchors.margins: 5
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        GridLayout {
            columns: 2
            Layout.fillWidth: true

            Label {
                text: "Channel:"
            }

            TextField {
                id: twitchChannel
                Layout.fillWidth: true
                text: app.twitchSettings.channel
            }
        }

        Button {
            text: "(Re-)Login"
            onClicked: {
                app.twitchApi.logout();
            }
        }

    }
}

