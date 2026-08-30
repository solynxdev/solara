pragma Singleton

import QtQuick

Item {
    id: root

    property string currentPath: ""

    function setWallpaper(path) {
        if (!path || path.length === 0)
            return

        root.currentPath = path
        ConfigManager.set("wallpaper", path)
    }

    function clearWallpaper() {
        root.currentPath = ""
        ConfigManager.set("wallpaper", "")
    }

    Connections {
        target: ConfigManager

        function onConfigLoaded() {
            root.currentPath =
                ConfigManager.get("wallpaper", "")
        }
    }

    Component.onCompleted: {
        if (ConfigManager.loaded)
            root.currentPath = ConfigManager.get("wallpaper", "")
    }
}
