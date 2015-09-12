import qbs 1.0

Application {
    name: "Overlord"

    Group {
        name: "Sources"
        files: [
            "TwitchApi/twitchapi.cpp",
            "TwitchApi/twitchapi.h",
            "main.cpp",
        ]
    }

    Group {
        name: "Resources"
        files: ["qml.qrc"]
    }

    Group {
        name: "Qml"
        files: [
            "JumpingText.qml",
            "Settings/TwitchSettings.qml",
            "SettingsWindow.qml",
            "TextLine.qml",
            "Twitch.qml",
            "main.qml",
            "Content.qml",
            "Database.qml",
            "Marquee.qml",
            "Toolbar.qml",
        ]
    }

    cpp.includePaths: [ "C:/Qt/5.5/msvc2013_64/include/QtQuick/5.5.0/QtQuick" ]
    //cpp.libraryPaths: ["c:/OpenSSL-Win32/lib/VC"]

    //cpp.dynamicLibraries: ["ssleay32", "libeay32" ]

    cpp.staticLibraries: [
        "User32.lib",
    ]

    Depends {
        name: "cpp"
    }

    Depends {
        name: "Qt";
        submodules: ["core", "gui", "network", "quick", "declarative", "webkit"]
    }
}
