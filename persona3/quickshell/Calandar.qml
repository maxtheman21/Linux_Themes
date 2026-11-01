import Quickshell
import Quickshell.Io

import QtQuick
import QtQuick.Controls

import Quickshell.Wayland

PanelWindow{

    property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`

    signal buttonClicked()

    id: calandar

    visible: true

    anchors.top: true
    anchors.right: true

    width: screen.width
    height: screen.height

    color: "transparent"
    WlrLayershell.layer: WlrLayer.Bottom

    function toggleVisible(): void {
        calandar.visible = !calandar.visible
    }

    FontLoader{
        id: rodinFont
        source: "./fonts/FOT-Rodin Pro B.otf"
    }

    Item{
        id: widget

        anchors.top: parent.top
        anchors.right: parent.right

        width: parent.width / 4
        height: parent.height / 8

        

        SystemClock{
            id: clock
            precision: SystemClock.Seconds
        }

        Button{

            width: widget.width
            height: widget.height

            background: Rectangle{
                color: "darkblue"
                width: widget.width
                height: widget.height
            }

            Row{

                width: widget.width
                height: widget.height

                spacing: 25

                

                Text{

                    id: time

                    text: Qt.formatDateTime(clock.date, "hh:mm")

                    font.family: rodinFont.name
                    font.pixelSize: 70                
                    color: "white"

                    anchors.verticalCenter: parent.verticalCenter

                }

                Column{

                    anchors.verticalCenter: parent.verticalCenter

                    spacing: 10

                    Row{

                        spacing: 20
                    
                        Text{

                            id: date

                            text: Qt.formatDateTime(clock.date, "MM/dd")

                            color: "white"
                            font.family: rodinFont.name
                            font.pixelSize: 35                
                            
                        }

                        Text{
                            id: dayOfWeek

                            text: clock.date.toLocaleDateString(Qt.locale(), "ddd")

                            color: "white"
                            font.family: rodinFont.name
                            font.pixelSize: 35 
                        }

                    }

                    Text{

                        id: timeOfDay

                        text: clock.hours < 6 ? "Night" : clock.hours < 12 ? "Early Morning" : clock.hours < 18 ? "Afternoon" : clock.hours < 24 ? "Evening" : "Unknown"

                        color: "cyan"
                        font.family: rodinFont.name
                        font.pixelSize: 35    
                    }

                }
            }

            onClicked: {
                calandar.buttonClicked()
            }

        }
    }
}