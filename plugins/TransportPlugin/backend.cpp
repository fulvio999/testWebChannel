/*
 * Copyright (C) 2021  fulvio
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * testWebChannel is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QtQml>
#include <QtQml/QQmlContext>

#include "webSocketTransport.h"
#include "backend.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>


void WebSocketTransportPlugin::registerTypes(const char *uri) {
    Q_ASSERT(uri == QLatin1String("TransportPlugin"));

    qmlRegisterType<WebSocketTransport>(uri, 1, 0, "SocketTransport");
}

void WebSocketTransportPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
