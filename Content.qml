import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import QtMultimedia 5.5

Item {
	Image {
		id: fakeGame
		source: "./Images/Hearthstone.jpg"
		anchors.centerIn: parent
	}

	Marquee {
		anchors.left: parent.left
		anchors.right: parent.right
		height: 50

		text: "Donators in September 2015: Marcus: 3$, Tobi: 4$, Schiff: 5$"
	}

	Item {
		id: cameraView

		anchors.right: parent.right
		anchors.bottom: parent.bottom

		width: 320
		height: 240

		VideoOutput {
			source: camera
			anchors.fill: border
			focus : visible
			fillMode: VideoOutput.PreserveAspectCrop
		}

		BorderImage {
			id: border
			source: "./Images/Border.png"
			anchors.fill: parent
			border {
				left: 20;
				top: 20
				right: 20;
				bottom: 20;
			}
			horizontalTileMode: BorderImage.Stretch
			verticalTileMode: BorderImage.Stretch
		}
	}

	Rectangle {
		color: "black"
		anchors {
			left: cameraView.left
			right: cameraView.right
			bottom: cameraView.top
		}
		height: 30

		Text {
			id: label
			anchors.centerIn: parent
			color: "white"
			text: "Kreygasm: 100.00€"
			scale: (parent.width / width)*0.9
		}
	}
}

