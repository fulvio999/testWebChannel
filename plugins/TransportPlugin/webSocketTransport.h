#ifndef WEBSOCKETTRANSPORT_H
#define WEBSOCKETTRANSPORT_H

#include <QtWebChannel/QWebChannelAbstractTransport>


class WebSocketTransport : public QWebChannelAbstractTransport
{
    Q_OBJECT

public:
    Q_INVOKABLE void sendMessage(const QJsonObject &message) override;

    Q_INVOKABLE void textMessageReceive(const QString &messageData);

signals:
    void messageChanged(const QString & message);
};

#endif // WEBSOCKETTRANSPORT_H

