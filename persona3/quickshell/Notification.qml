import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Services.Notifications

Item {

    ListModel {
        id: notifModel
    }

    NotificationServer {
        id: server
        onNotification: (n) => {
            notifModel.append({body: n.body, summary: n.summary})
        }
    }

    Repeater {
        model: notifModel
        delegate: PanelWindow {
            property var modelData
            width: 100
            height: 100
            anchors {
                right: true
                top: true
            }
            Text {
                anchors.centerIn: parent
                text: Quickshell.env("USER")
            }
        }
    }

    Component.onCompleted: console.log("modelData:", JSON.stringify(modelData))

}