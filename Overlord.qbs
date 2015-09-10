import qbs 1.0

Application {
    name: "Overlord"

    Group {
        name: "Sources"
        files: ["main.cpp"]
    }

    Group {
        name: "Resources"
        files: ["qml.qrc"]
    }

    Group {
        name: "Qml"
        files: [
            "main.qml",
            "Content.qml",
            "Database.qml",
            "Marquee.qml",
            "Toolbar.qml",
        ]
    }

    Depends {
        name: "cpp"
    }

    Depends {
        name: "Qt";
        submodules: ["core", "gui", "network", "quick"]
    }

}
