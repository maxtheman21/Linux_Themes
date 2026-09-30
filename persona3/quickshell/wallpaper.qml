import Quickshell
import QtQuick
import QtMultimedia
import Quickshell.Wayland


ShellRoot {
	Variants {
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
				id: mainWallpaper
				anchors.fill: parent
				source: "file:///home/maxh/.themes/persona3/wallpaper/default.jpg"
				smooth: true

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
			source: "file:///home/maxh/.themes/persona3/wallpaper/Intro_P3.mp4"
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
			source: "file:///home/maxh/.themes/persona3/wallpaper/Loop_P3.mp4"
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
}
