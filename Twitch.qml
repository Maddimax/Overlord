import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.Dialogs 1.2

import com.overlord.twitchapi 1.0

Item {
    id: twitchLogin
    anchors.fill: parent

    property alias channel: twitchApiInstance.channel;

    property TwitchApi twitchApi: twitchApiInstance

    TwitchApi {
        id: twitchApiInstance

        function logout() {
            webView.forceRelogin = true;
            webView.url = webView.loginUrl
            webView.reload();
            loginDialog.open();
        }
    }

    Component.onCompleted: {
        loginDialog.open();
    }

    Dialog {
        id: loginDialog
        visible: true
        title: "Twitch Login"

        modality: Qt.ApplicationModal

        contentItem: Item {

            implicitWidth: 400
            implicitHeight: 500

            Text {
                anchors.centerIn: parent
                color: "black"
                font.pixelSize: 25
                text: "Logging into Twitch ..."
            }

            WebView {
                id: webView
                anchors.fill: parent

                property bool forceRelogin: false

                property url loginUrl: forceRelogin ? loginUrlForce : loginUrlNoForce;
                property url loginUrlForce: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=lpnyoldpzw8n7nziazjukfjfkrp0ppw&redirect_uri=http://localhost&scope=channel_subscriptions&state=12345678&force_verify=true&authenticity_token=" + twitchApi.authToken
                property url loginUrlNoForce: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=lpnyoldpzw8n7nziazjukfjfkrp0ppw&redirect_uri=http://localhost&scope=channel_subscriptions&state=12345678"
                url: loginUrl
                onNavigationRequested: {
                    // detect URL scheme prefix, most likely an external link
                    var url = request.url.toString();

                    if (url.indexOf("http://localhost") == 0) {
                        console.log(url)
                        var authTokenPattern = /access_token=([a-zA-Z0-9]*)/
                        var res = authTokenPattern.exec(url);

                        request.action = WebView.IgnoreRequest;

                        if(res != null) {
                            twitchApi.authToken = res[1];
                        }

                        loginDialog.close()
                    }
                    else
                    {
                        request.action = WebView.AcceptRequest;
                    }
                }
            }
        }
    }


}

