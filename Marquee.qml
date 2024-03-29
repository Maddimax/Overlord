import QtQuick 2.0

Text {
	id: marquee

	property string text
	property string divider: " --- "
	property real timePerRevolution: 20000

    color: "white"
    style: Text.Outline;
    styleColor: "black"
    font.pixelSize: height -2
    font.family: app.defaultFont.family
    font.bold: app.defaultFont.bold


	onTextChanged: {
		updateText();
	}

	function updateText() {
		marqueeAnim.stop();

		marqueeLabel.text = text

		if(text.length > 0)
		{
			marqueeLabel.text += divider
			singleWidth = marqueeLabel.contentWidth

			while(marqueeLabel.contentWidth < width * 2)
				marqueeLabel.text += text + divider;

			marqueeAnim.to = -singleWidth;
			marqueeAnim.duration = (singleWidth / width) * timePerRevolution;
			marqueeAnim.start();
		}
	}

	property real singleWidth;

	Component.onCompleted: {
		updateText();
	}

	NumberAnimation {
		id: marqueeAnim
		target: marqueeLabel
		properties: "x"
		duration: 5000
		from: 0
		to: -singleWidth
		loops: Animation.Infinite
	}

	Text {
		id: marqueeLabel

		font.family: app.defaultFont.family

        color: parent.color
        style: parent.style
        styleColor: parent.styleColor
        font.pixelSize: parent.font.pixelSize
		anchors.verticalCenter: parent.verticalCenter
	}
}
