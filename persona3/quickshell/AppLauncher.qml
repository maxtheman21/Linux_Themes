import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Io

import QtQuick
import QtQuick.Controls
import QtQml.Models

// TODO
//
// Fix Screen Grab
// Fix and implement Favorites
// 


PanelWindow{

        id: launcher

        focusable: true
        visible: false

        implicitWidth: screen ? screen.width / 3.5 : 200
        implicitHeight: screen ? screen.height / 1.75 : 100

        property var filteredApps: []
        property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`
        property bool mouseDisabled: false

        Image {
            id: mainWallpaper
            anchors.fill: parent
            source: imgPath+`app_launcher_background.png`
            smooth: true

        }

        FontLoader{
            id: linBiolinum
            source: "./fonts/LinBiollinum_RB.ttf"
        }

        color: "transparent"

        property var appCache: {
            let apps = [];
            let keys = Object.keys(DesktopEntries.applications.values);
            for(let i = 0; i < keys.length; i++){
                let app = DesktopEntries.applications.values[keys[i]];
                apps.push({
                    "name" : app.name || "",
                    "description" : app.genericName || "",
                    "icon" : app.icon || "",
                    "entry" : app
                });
            }
            return apps
        }

        onAppCacheChanged: updateModel(search.text)

        function updateModel(searchQuery){
            let query = searchQuery.toLowerCase().trim();
            
            let results = appCache.filter(app => {
                if (query === "") return true;
                return app.name.toLowerCase().includes(query);
            });

            results.sort((a, b) => a.name.localeCompare(b.name));
            filteredApps = results;
        }
        
        TextField {
            id: search
            placeholderText: "Search apps..."
            onTextChanged: launcher.updateModel(text)
            implicitWidth: launcher.implicitWidth
            focus: true

            Keys.onPressed: (event) => {
                if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    console.log("Selected: " + view.model[view.currentIndex]);
                    view.model[view.currentIndex].entry.execute();
                    ipc.toggleVisible();
                }
                else if (event.key === Qt.Key_Up) {
                    if(view.currentIndex > 0) {
                        view.currentIndex--;
                    }
                }
                else if (event.key === Qt.Key_Down) {
                    if(view.currentIndex < view.count - 1) {
                        view.currentIndex++;
                    }
                }
            }
        }

        ListView {
            id: view

            spacing: 10

            implicitWidth: screen ? screen.width / 4: 150
            implicitHeight: screen ? screen.height / 2.5 : 50

            anchors.centerIn: parent

            model: launcher.filteredApps
            currentIndex: 0

            delegate: Rectangle {

                height: screen ? screen.height / 15 : 50
                width: screen ? screen.width / 4: 150

                property bool isCurrent: (view.currentIndex === index)

                color: "transparent"

                Image{
                    id: applicationBackground
                    anchors.centerIn: parent
                    source: isCurrent ? imgPath+`applicationBackgroundActive` : imgPath+`applicationBackground`
                    height: screen ? screen.height / 12 : 50
                    width: screen ? screen.width / 4: 150
                    // anchors.verticalCenterOffset: -20
                }

                Row{
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 18
                    spacing: 10

                    IconImage { 
                        source: modelData.icon ? "image://icon/" + modelData.icon : "image://icon/application-x-executable"
                        width: 32
                        height: 32

                        transform: Translate {
                            y: 12
                        }

                    } 

                    Column {
                    spacing: 1

                        Text { 
                            text: modelData.name
                            font.family: linBiolinum.name
                            font.pointSize: 16
                            color: "#ffffff"
                        } // Main Name
                        Text { 
                            text: modelData.description
                            font.family: linBiolinum.name
                            font.pointSize: 10  
                            color: "#ffffff"
                        } // General Purpose
                    }
                }

                Button{
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.top: parent.top
                    anchors.topMargin: 10

                    width: 32
                    height: 32

                    Image {
                        id: secondaryWallpaper
                        anchors.fill: parent
                        source: imgPath+`default.jpg`
                        smooth: true

                    }
                }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent

                    onEntered: {
                        view.currentIndex = index
                    }

                    onClicked: {
                        modelData.entry.execute()
                        ipc.toggleVisible()
                    }
                }
            }
        }
    
    IpcHandler {
        target: "launcher"
        id: ipc

        function toggleVisible(): void {
            launcher.visible = !launcher.visible
            grab.active = !grab.active
            search.text = ""
            view.positionViewAtBeginning()
        }
    }
    
}    
