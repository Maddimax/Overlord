#include "twitchapi.h"

#include <QUrlQuery>
#include <QNetworkRequest>
#include <QRegExp>

#include <QQuickItem>

#include <QJsonValue>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>


TwitchApi::TwitchApi(QObject *parent)
    : QObject(parent)
    , _resetFollows(false)
    , _resetSubscribers(false)
{
    _networkAccessManager = new QNetworkAccessManager(this);
    connect(_networkAccessManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));
    connect(&_updateTimer, &QTimer::timeout, this, &TwitchApi::onTimer);


    _updateTimer.setInterval(30000);
    _updateTimer.start();
}

QString TwitchApi::channel() const
{
    return m_channel;
}


QString TwitchApi::authToken() const
{
    return m_authToken;
}

void TwitchApi::setAuthToken(QString authToken)
{
    if (m_authToken == authToken)
        return;

    m_authToken = authToken;
    emit authTokenChanged(authToken);

    _resetFollows = true;
    _resetSubscribers = true;

    onTimer();
}

void TwitchApi::setChannel(QString channel)
{
    if (m_channel == channel)
        return;

    m_channel = channel;
    emit channelChanged(channel);

    _resetFollows = true;
    _resetSubscribers = true;

    onTimer();
}

void TwitchApi::replyFinished(QNetworkReply* reply)
{
    QByteArray data = reply->readAll();

    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);

    if(!doc.isNull())
    {
        if(doc.isObject())
        {
            QJsonObject root = doc.object();

            if(root.contains("error"))
            {
                qDebug() << "Error occured:";
                qDebug() << doc.toJson();
            }

            if(root.contains("follows"))
                parseFollowers(root);
            else if(root.contains("subscriptions"))
                parseSubscribers(root);
        }
        else if(doc.isArray())
        {
        }
    }

    if(error.error !=  QJsonParseError::NoError)
    {
        qDebug() << "Error parsing Json reply:" << error.errorString();
    }

}

void TwitchApi::requestFollowers(int offset)
{
    QUrl url(QString("https://api.twitch.tv/kraken/channels/%1/follows?offset=%2&limit=100").arg(m_channel).arg(offset));

    QNetworkRequest followerRequest(url);
    _networkAccessManager->get(followerRequest);
}

void TwitchApi::onTimer()
{
    if(m_channel.isEmpty() || m_authToken.isEmpty())
        return;

    requestFollowers();
    requestSubscribers();
}

void TwitchApi::parseFollowers(QJsonObject root)
{
    qDebug() << root.keys();

    _numFollowersTotal = root["_total"].toInt();
    QJsonArray follows = root["follows"].toArray();

    QSet<QString> newFollows = parseUserList(follows);

    if(_resetFollows)
    {
        _latestFollowers = newFollows;
        _resetFollows = false;
    }
    else
    {
        QSet<QString> addedEntries = newFollows;
        addedEntries.subtract(_latestFollowers);

        QSet<QString>::iterator it = addedEntries.begin();
        for(;it != addedEntries.end();++it)
        {
            emit newFollower(*it);
        }

        _latestFollowers += addedEntries;
    }

    qDebug() << "Total Followers:" << _numFollowersTotal << ", cached:" << _latestFollowers.size();

}

void TwitchApi::requestSubscribers(int offset)
{
    QUrl url(QString("https://api.twitch.tv/kraken/channels/%1/subscriptions?offset=%2&limit=100").arg(m_channel).arg(offset));

    QNetworkRequest subscriptionsRequest(url);
    subscriptionsRequest.setRawHeader("Accept", "application/vnd.twitchtv.v3+json" );
    subscriptionsRequest.setRawHeader("Authorization", QString("OAuth %1").arg(m_authToken).toUtf8());
    _networkAccessManager->get(subscriptionsRequest);
}

void TwitchApi::parseSubscribers(QJsonObject root)
{
    qDebug() << root.keys();

    _numSubscribersTotal = root["_total"].toInt();
    QJsonArray subscriptions = root["subscriptions"].toArray();

    QSet<QString> newSubscriptions = parseUserList(subscriptions);

    if(_resetSubscribers)
    {
        _latestSubscribers = newSubscriptions;
        _resetSubscribers = false;
    }
    else
    {
        QSet<QString> addedEntries = newSubscriptions;
        addedEntries.subtract(_latestSubscribers);

        QSet<QString>::iterator it = addedEntries.begin();
        for(;it != addedEntries.end();++it)
        {
            emit newSubscriber(*it);
        }

        _latestSubscribers += addedEntries;
    }

    qDebug() << "Total Subscribers:" << _numSubscribersTotal << ", cached:" << _latestSubscribers.size();
}

QSet<QString> TwitchApi::parseUserList(QJsonArray list)
{
    QSet<QString> entries;
    for(QJsonArray::Iterator it = list.begin();it != list.end();++it)
    {
        QJsonObject user = (it->toObject())["user"].toObject();

        if(!user.isEmpty())
        {
            QString displayName = user["display_name"].toString();
            entries.insert(displayName);
        }
    }

    return entries;
}



