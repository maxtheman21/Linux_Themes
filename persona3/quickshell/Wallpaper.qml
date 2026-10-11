import Quickshell
import QtQuick
import QtMultimedia
import Quickshell.Wayland


ShellRoot {

    property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`


	Variants {
		id: defaultWallpaper
		model: Quickshell.screens

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
				id: secondaryWallpaper
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
			id: defaultScreensaver
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
					source: imgPath`screensaver.jpg`
					smooth: true

				}
			}
		}
	}

	PanelWindow {
		
		screen: Quickshell.screens.find(s => s.name === "DP-2")
		WlrLayershell.layer: WlrLayer.Background
		anchors {
			left: true
			right: true
			bottom: true
			top: true			
		}
	
		MediaPlayer {
			id: intro
			source: imgPath+`Intro_P3.mp4`
			autoPlay: true
			videoOutput: videoIntro
			
			onMediaStatusChanged: {
				if (mediaStatus === MediaPlayer.EndOfMedia) {
					loop.play()
					videoLoop.visible = true
					videoIntro.visible = false
				}
			}
		}

		VideoOutput {
			id: videoIntro
			anchors.fill:parent
		}

		MediaPlayer {
			id: loop
			source: imgPath+`Loop_P3.mp4`
			videoOutput: videoLoop
			loops: MediaPlayer.Infinite
		}

		VideoOutput {
			id: videoLoop
			anchors.fill: parent
			visible: false
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

