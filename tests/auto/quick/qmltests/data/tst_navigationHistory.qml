/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the QtWebEngine module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** As a special exception, The Qt Company gives you certain additional
** rights. These rights are described in The Qt Company LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0
import QtWebEngine 1.2

TestWebEngineView {
    id: webEngineView
    width: 400
    height: 300

    ListView {
        id: backItemsList
        anchors.fill: parent
        model: webEngineView.navigationHistory.backItems
        currentIndex: count - 1
        delegate:
            Text {
                color:"black"
                text: url
            }
    }

    ListView {
        id: forwardItemsList
        anchors.fill: parent
        model: webEngineView.navigationHistory.forwardItems
        currentIndex: 0
        delegate:
            Text {
                color:"black"
                text: url
            }
    }

    TestCase {
        name: "WebEngineViewNavigationHistory"

        function test_navigationHistory() {
            compare(webEngineView.loadProgress, 0)

            webEngineView.url = Qt.resolvedUrl("test1.html")
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.canGoBack, false)
            compare(webEngineView.canGoForward, false)
            compare(backItemsList.count, 0)
            compare(forwardItemsList.count, 0)

            webEngineView.url = Qt.resolvedUrl("test2.html")
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("test2.html"))
            compare(webEngineView.canGoBack, true)
            compare(webEngineView.canGoForward, false)
            compare(backItemsList.count, 1)
            compare(backItemsList.currentItem.text, Qt.resolvedUrl("test1.html"))

            webEngineView.goBackOrForward(-1)
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("test1.html"))
            compare(webEngineView.canGoBack, false)
            compare(webEngineView.canGoForward, true)
            compare(backItemsList.count, 0)
            compare(forwardItemsList.count, 1)
            compare(forwardItemsList.currentItem.text, Qt.resolvedUrl("test2.html"))

            webEngineView.goForward()
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("test2.html"))
            compare(webEngineView.canGoBack, true)
            compare(webEngineView.canGoForward, false)
            compare(backItemsList.count, 1)
            compare(forwardItemsList.count, 0)
            compare(backItemsList.currentItem.text, Qt.resolvedUrl("test1.html"))

            webEngineView.url = Qt.resolvedUrl("javascript.html")
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("javascript.html"))
            compare(webEngineView.canGoBack, true)
            compare(webEngineView.canGoForward, false)
            compare(backItemsList.count, 2)
            compare(forwardItemsList.count, 0)
            compare(backItemsList.currentItem.text, Qt.resolvedUrl("test1.html"))

            webEngineView.goBackOrForward(-2)
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("test1.html"))
            compare(webEngineView.canGoBack, false)
            compare(webEngineView.canGoForward, true)
            compare(backItemsList.count, 0)
            compare(forwardItemsList.count, 2)
            compare(forwardItemsList.currentItem.text, Qt.resolvedUrl("test2.html"))

            webEngineView.goBackOrForward(2)
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("javascript.html"))
            compare(webEngineView.canGoBack, true)
            compare(webEngineView.canGoForward, false)
            compare(backItemsList.count, 2)
            compare(forwardItemsList.count, 0)
            compare(backItemsList.currentItem.text, Qt.resolvedUrl("test1.html"))

            webEngineView.goBack()
            verify(webEngineView.waitForLoadSucceeded())
            compare(webEngineView.url, Qt.resolvedUrl("test2.html"))
            compare(webEngineView.canGoBack, true)
            compare(webEngineView.canGoForward, true)
            compare(backItemsList.count, 1)
            compare(forwardItemsList.count, 1)
            compare(backItemsList.currentItem.text, Qt.resolvedUrl("test1.html"))
            compare(forwardItemsList.currentItem.text, Qt.resolvedUrl("javascript.html"))
        }
    }
}
