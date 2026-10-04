import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Controls

PanelWindow{

        id: launcher

        visible: false
        implicitWidth: screen ? screen.width / 3.5 : 200
        implicitHeight: screen ? screen.height / 1.75 : 100

        Image {
            id: mainWallpaper
            anchors.fill: parent
            source: `file:///home/${Quickshell.env("USER")}/.themes/persona3/wallpaper/app_launcher_background.mp4`
            smooth: true

        }

        // radius: 12
        // antialiasing: true
        
        // border.color: "black"
        // border.width: 2
        // border.pixelAligned: true


        color: "red"

        // TextField {
        //     id: search
        //     implicitWidth: screen ? screen.width / 4: 150
        //     placeholderText: "Search..."
        //     OnTextChanged: {}
        // }

        ListView {
            id: view

            spacing: 10

            implicitWidth: screen ? screen.width / 4: 150
            implicitHeight: screen ? screen.height / 2.5 : 50

            anchors.centerIn: parent

            model: DesktopEntries.applications
            delegate: Rectangle {
                // property bool matchesSearch: model.name.toLowerCase().includes(searchInput.text.toLowerCase())
                // id: wrapper

                // visble: matchesSearch

                height: screen ? screen.height / 15 : 50
                width: screen ? screen.width / 4: 150

                color: ListView.isCurrentItem ? "black" : "red"


                radius: 12
                antialiasing: true

                border.color: "black"
                border.width: 2
                border.pixelAligned: true

                // Image { source: "/usr/share/icons/hicolor/256x256/apps/"+modelData.icon+".png" } // I cannot find the icon path for .desktop

                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    spacing: 2

                    Text { 
                        text: modelData.name
                        font.pointSize: 16
                        color: "#ffffff"
                    } // Main Name
                    Text { 
                        text: modelData.genericName
                        font.pointSize: 10  
                        color: "#ffffff"
                    } // General Purpose
                }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onEntered: {
                        view.currentIndex = index
                    }

                    onClicked: {
                        launcher.visible = false
                        modelData.execute()
                    }
                }
            }
            focus: true
        }
    
    IpcHandler {
        target: "launcher"

        function toggleVisible(): void {
            launcher.visible = !launcher.visible
        }
    }
    
}    