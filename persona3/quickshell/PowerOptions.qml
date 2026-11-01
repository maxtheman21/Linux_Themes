import Quickshell
// import Quickshell.Widgets
import Quickshell.Io

import QtQuick
import QtQuick.Controls
// import QtQml.Models

Item {
    id: powerOptions

    required property var panelWindow

    width: panelWindow.width
    height: panelWindow.height / 4

    visible: true

    Item{
        id: options

        Row {
            height: 10
            anchors.fill: parent
            spacing: 10

            Button {
                id: shutdown
                text: "Shutdown"
                width: powerOptions.width / 4
                height: powerOptions.width / 4


                Process {
                    id: shutdownProcess
                    command: ["systemctl", "poweroff"]
                }

                onClicked: {
                    shutdownProcess.running = true
                }
            }
            Button {
                id: reboot
                text: "Restart"
                width: powerOptions.width / 4
                height: powerOptions.width / 4

                
                Process {
                    id: rebootProcess
                    command: ["systemctl", "reboot"]
                }

                onClicked: {
                    rebootProcess.running = true
                }
            }
            Button {
                id: sleep
                text: "Sleep"
                width: powerOptions.width / 4
                height: powerOptions.width / 4
                
                Process {
                    id: sleepProcess
                    command: ["systemctl", "sleep"]
                }

                onClicked: {
                    sleepProcess.running = true
                }
            }
        }
    }



    IpcHandler {
        target: "powerMenu"
        id: ipc

        function toggleVisible(): void {
            powerOptions.visible = !powerOptions.visible
        }
    }

}