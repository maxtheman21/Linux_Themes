import Quickshell
import QtQuick
import QtMultimedia
import Quickshell.Wayland

// TODO
//
// Change Screensaver?

ShellRoot {

    property string imgPath: `file:///home/${Quickshell.env("USER")}/.themes/persona3/images/`

	QtObject {
		signal globalTrigger()
	}



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
		property real screensaverVisible: 0

		NumberAnimation {
			id: transitionOpacity
			target: screensaver
			property: "screensaverVisible"
			duration: 5000
			easing.type: Easing.InOutQuad
			from: 0.0
			to: 1.0
		}

		Variants {
			id: defaultScreensaver
			model: Quickshell.screens

			delegate: PanelWindow {

				property var modelData
				screen: modelData

				mask: Region {
					// item: options
				}

				color: "transparent"

				WlrLayershell.layer: WlrLayer.Overlay
				anchors {
					left: true
					right: true
					bottom: true
					top: true			
				}

				Image {
					opacity: screensaver.screensaverVisible
					id: secondaryScreensaver
					anchors.fill: parent
					source: imgPath+`screensaver.png`
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
		
		Item{
			Dropdown {
				id: dropdownRoot
				onButtonClicked: {
					calandarRoot.toggleVisible()
					dropdownRoot.toggleVisible()
				}
			}
			Calandar {
				id: calandarRoot
				onButtonClicked: {
					calandarRoot.toggleVisible()
					dropdownRoot.toggleVisible()
				}
			}
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

		onIsIdleChanged: {
			if(isIdle){
				transitionOpacity.restart()
			}
			else{
				transitionOpacity.pause()
				screensaver.screensaverVisible = 0
			}
		}
	}
}