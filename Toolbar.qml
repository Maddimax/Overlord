import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ToolBar {
	RowLayout {
		height: parent.height
		Text {
			text: "Scene:"
			Layout.fillWidth: false
		}

		ComboBox {
			model: app.database.sceneModel
			//onCurrentIndexChanged: console.debug(model.get(currentIndex).name)
		}
	}
}

