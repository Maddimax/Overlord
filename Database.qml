import QtQuick 2.0
import QtQuick.LocalStorage 2.0

Item {
	id: database

	Component.onCompleted: {
		console.log("Opening Database ...")
		initialize();
		console.log("Database opened.")
	}

	property ListModel sceneModel: ListModel {
	}

	function initialize() {
		var db = LocalStorage.openDatabaseSync("OverlordDB", "1.0", "Settings", 1000000);

		db.transaction(
					function(tx) {
						// Create the database if it doesn't already exist
						tx.executeSql('CREATE TABLE IF NOT EXISTS Scenes(name TEXT)');

						// Add (another) greeting row
						/*tx.executeSql('INSERT INTO Scenes VALUES(?)', [ 'Default' ]);
						tx.executeSql('INSERT INTO Scenes VALUES(?)', [ 'Hearthstone' ]);
						tx.executeSql('INSERT INTO Scenes VALUES(?)', [ 'HOTS' ]);
*/

						// Show all added greetings
						var rs = tx.executeSql('SELECT * FROM Scenes');

						var r = ""
						for(var i = 0; i < rs.rows.length; i++)
						{
							sceneModel.append( {'name' : rs.rows.item(i).name } );
						}
					}
					)
	}

}

