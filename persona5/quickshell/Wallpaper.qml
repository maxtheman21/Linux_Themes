import Quickshell
import QtQuick
import QtMultimedia
import Quickshell.Wayland


ShellRoot {

    property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`

	Variants {
		
		model: Quickshell.screens

		// This is where the secondary monitors are assigned wallpapers, which is a default non-gif wallpaper 

		delegate: PanelWindow {
			property var modelData
			screen: modelData
			WlrLayershell.layer: WlrLayer.Background
			anchors {
				left: true
				right: true
				bottom: true
				top: true			
			}

			Image {
				id: mainWallpaper
				anchors.fill: parent
				source: imgPath+`default.jpg`
				smooth: true

			}
		}
	}

	Item{
		id: screensaver
		property bool screensaverVisible: false

		Variants {
			
			model: Quickshell.screens

			delegate: PanelWindow {

				property var modelData
				screen: modelData

				visible: screensaver.screensaverVisible

				WlrLayershell.layer: WlrLayer.Overlay
				anchors {
					left: true
					right: true
					bottom: true
					top: true			
				}

				Image {
					id: secondaryScreensaver
					anchors.fill: parent
					source: imgPath+`screensaver.png`
					smooth: true

				}
			}
		}
	}

	PanelWindow {
		
		// This panelWindow is the main monitor, which will be a gif

		screen: Quickshell.screens.find(s => s.name === "DP-2") // DP-2 is my main monitor, this can be changed, or detected somehow?
		WlrLayershell.layer: WlrLayer.Background
		anchors {
			left: true
			right: true
			bottom: true
			top: true			
		}
	
		// This is a one-time played intro scene, that should seamless transition into the loop scene

		// MediaPlayer {
		// 	id: intro
		// 	source: `file:///home/${Quickshell.env("USER")}/.themes/persona5/wallpaper/Intro_P3.mp4`
		// 	autoPlay: true
		// 	videoOutput: videoIntro
			
		// 	onMediaStatusChanged: {
		// 		if (mediaStatus === MediaPlayer.EndOfMedia) {
		// 			loop.play()
		// 			videoLoop.visible = true
		// 			videoIntro.visible = false
		// 		}
		// 	}
		// }

		// VideoOutput {
		// 	id: videoIntro
		// 	anchors.fill:parent
		// }

		// This is the main loop that will play infinitely

		MediaPlayer {
			id: loop
			source: imgPath+`main.jpg`
			videoOutput: videoLoop
			autoPlay: true
			loops: MediaPlayer.Infinite
		}

		VideoOutput {
			id: videoLoop
			anchors.fill: parent
			visible: true
		}

		Component.onCompleted: {
			loop.play()
			loop.pause()
		}
	}

	IdleMonitor {
		id: idle
		timeout: 300
		respectInhibitors: false
		onIsIdleChanged: {
			if (isIdle) {
				screensaver.screensaverVisible = true
				// idle monitor, a panel window that is displayed in front of everything
			}
			else { // would only trigger after IsIdle is changed to false, or user "wakes" the computer up
				// if (LockScreenEnabled) {
				// 	// goto lockscreen
				// }
				// else{
					screensaver.screensaverVisible = false
				// }
			}
		}
	}

}
