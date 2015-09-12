#ifndef TWITCHAPI_H
#define TWITCHAPI_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QStringListModel>
#include <QSet>
#include <QQuickItem>

#include <QTimer>

class TwitchApi : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString authToken READ authToken WRITE setAuthToken NOTIFY authTokenChanged)
    Q_PROPERTY(QString channel READ channel WRITE setChannel NOTIFY channelChanged)

public:
    explicit TwitchApi(QObject *parent = 0);

signals:
    void authTokenChanged(QString authToken);
    void channelChanged(QString channel);
    void followersChanged(QStringListModel* followers);

    void newFollower(QString name);
    void newSubscriber(QString name);

public slots:
    QString authToken() const;
    void setAuthToken(QString authToken);

    void setChannel(QString channel);
    QString channel() const;

private slots:
    void replyFinished(QNetworkReply*);
    void onTimer();

private:
    void requestFollowers(int offset=0);
    void parseFollowers(QJsonObject root);

    void requestSubscribers(int offset=0);
    void parseSubscribers(QJsonObject root);

    QSet<QString> parseUserList(QJsonArray list);

private:
    QNetworkAccessManager* _networkAccessManager;
    QString m_authToken;

    QTimer _updateTimer;
    QString m_channel;


    QSet<QString> _latestFollowers;
    int _numFollowersTotal;

    QSet<QString> _latestSubscribers;
    int _numSubscribersTotal;

    bool _resetFollows;
    bool _resetSubscribers;
};

#endif // TWITCHAPI_H
