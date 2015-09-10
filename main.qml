import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import QtMultimedia 5.5

ApplicationWindow {
	id: app
	visible: true
	title: qsTr("Overlord")

	property real baseWidth: 1920
	property real baseHeight: 1080

	property font defaultFont: {
		family: "Arial Rounded MT Bold"
	}

	width: 1920/2
	height: 1080/2

	property real scaleFactor: width / baseWidth

	toolBar: Toolbar { }

	property Database database : Database { }

	Camera {
		id: camera

		imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

		exposure {
			exposureCompensation: -1.0
			exposureMode: Camera.ExposurePortrait
		}

		flash.mode: Camera.FlashRedEyeReduction

		imageCapture {
			onImageCaptured: {
				photoPreview.source = preview  // Show the preview in an Image
			}
		}
	}

	Rectangle {
		id: content

		color: "grey"

		width: app.baseWidth
		height: app.baseHeight

		transform: Scale {
			xScale: app.scaleFactor
			yScale: app.scaleFactor
		}

		Content {
			anchors.fill: parent
		}
	}
}


