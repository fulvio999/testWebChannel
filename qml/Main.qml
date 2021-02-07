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

import QtQuick 2.7
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import Morph.Web 0.1
import QtWebEngine 1.7


import TransportPlugin 1.0


//example: https://doc-snapshots.qt.io/qt5-5.12/qtwebsockets-qmlwebsocketclient-example.html
import QtWebSockets 1.0
import QtWebChannel 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'testwebchannel.fulvio'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('testWebChannel')
        }

        ColumnLayout {
            spacing: units.gu(2)
            anchors {
                margins: units.gu(2)
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }


        // an object with properties, signals and methods - just like any normal Qt object
        QtObject {
            id: someObject

            /*
               ID, under which this object will be known at WebEngineView side (ie HTML page)
               This ID is used in the HTML page to read some property vales in the QML page
            */
            WebChannel.id: "backend"

            /* A sample property that can be accessed from html using the WebChannel.id value */
            property string someProperty: "I am QML property value"

            /* emit a signal named 'someSignal' that will be catched on html side */
            signal someSignal(string message);

            /* Update QML using received value from HTML
               Function called from HTML when the use press "Send" button */
            function changeText(receivedText) {
                console.log(receivedText);
                txt.text = "Received: "+receivedText;
                return "Received Text length: " + receivedText.length;
            }
        }

        SocketTransport {
            id: transport
        }

        WebSocketServer {
            id: server
            listen: true
            port: 55222
            onClientConnected: {
                //console.log(webSocket.status);
                if(webSocket.status === WebSocket.Open) {
                    channel.connectTo(transport)
                    webSocket.onTextMessageReceived.connect(transport.textMessageReceive)
                    transport.onMessageChanged.connect(webSocket.sendTextMessage)
                }
            }
            onErrorStringChanged: {
                console.log(qsTr("Server error: %1").arg(errorString));
            }

            /* Enable for DEBUG
              Component.onCompleted: {
                  console.log(server.url);
              }
            */
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.4
            border.width: 2
            border.color: "green"

            Label {
                text:"I am a QML page"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    topMargin: units.gu(4)
                }
            }

            /* show the text received from HTML page and raise a signal that will be received by html */
            Text {
                id: txt
                anchors.centerIn: parent
                font.pixelSize: 20
                color: "green"
                onTextChanged: {
                    /* this signal will trigger a function at WebView side (ie: HTML page) (if html is connected
                       at this signl, see index.html)
                    */
                    someObject.someSignal(text)
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.width: 2
            border.color: "blue"

            WebView {
                id: webView
                anchors.fill: parent
                anchors.margins: 5
                url: Qt.resolvedUrl('./www/index.html')
                onLoadingChanged: {
                    if (loadRequest.errorString)
                    {
                      console.error(loadRequest.errorString);
                    }
                }
            }

            WebChannel {
                id: channel
                registeredObjects: [someObject]
            }
        }

        }
    } //page
}
