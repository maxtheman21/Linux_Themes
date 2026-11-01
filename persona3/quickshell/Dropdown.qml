import Quickshell
import Quickshell.Io

import QtQuick
import QtQuick.Controls

import Quickshell.Wayland


PanelWindow {

    property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`

    signal buttonClicked()

    id: dropdown
    visible: false

    width: screen.width
    height: screen.height
    anchors.right: true
    anchors.top: true

    color: "transparent"

	WlrLayershell.layer: WlrLayer.Bottom

    // mask: Region {
    //     id: dropdownMask
    //     item: null
    // }

    MouseArea {
        width: screen.width
        height: screen.height

        onPressed: {
            dropdown.buttonClicked()
        }
    }

    Component.onCompleted: {
        window.contentItem.activeFocusChanged.connect(function() {
            if(!window.contentItem.activeFocus) {
                dropdown.buttonClicked()
            }
        })
    }


    Item{
        id: options

        width: dropdown.width / 4
        height: dropdown.height / 2.5

        anchors.right: parent.right
        anchors.top: parent.top
 
        Rectangle {
            width: parent.width
            height: parent.height

            color: "black"
        }

        Flow {
            
            anchors.fill: parent

            PowerOptions{
                panelWindow: options
            }
        }
    }



    function toggleVisible(): void {
        dropdown.visible = !dropdown.visible
    }
}

