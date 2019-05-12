import QtQuick 2.0
import QtQuick.Layouts 1.1

Text {
	id: jumpingText
	property string jumpingText: "Hallo Welt"

	width: layout.width
	height: font.pixelSize

	font.family: app.defaultFont.family
	font.pixelSize: 30

	style: Text.Outline
	styleColor: "black"
	color: "white"

	property real anim: 0.0

	SequentialAnimation {
		running: true
		loops: Animation.Infinite
		NumberAnimation {
			target: jumpingText
			property: "anim"
			from: -Math.PI
			to: Math.PI
			duration: 1000
		}
		NumberAnimation {
			target: jumpingText
			property: "anim"
			from: -Math.PI
			to: Math.PI
			duration: 1000
		}

		PauseAnimation {
			duration: 1000
		}
	}

	RowLayout {
		spacing: 0
		id: layout
		Repeater {
			model: jumpingText.jumpingText.length
			Text {
				text: jumpingText.jumpingText[index]

				color: jumpingText.color
				style: jumpingText.style
				styleColor: jumpingText.styleColor
				font: jumpingText.font

				y: -(Math.max(0.0, (Math.sin(jumpingText.anim + (((Math.PI)/jumpingText.jumpingText.length)*index)))*font.pixelSize/2.0));
			}
		}
	}
}

