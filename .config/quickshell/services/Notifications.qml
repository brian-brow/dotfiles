pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  property bool centerOpen: false

  NotificationServer {
    id: server

    keepOnReload: true
    persistenceSupported: true
    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    inlineReplySupported: true

    onNotification: function(notification) {
      console.log("notif received:", notification.appName, notification.summary)
      notification.tracked = true
    }
  }

  readonly property alias server: server
  readonly property var notifications: server.trackedNotifications

  function toggleCenter() {
    centerOpen = !centerOpen
  }

  function closeCenter() {
    centerOpen = false
  }
}
