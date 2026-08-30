import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    id: root

    required property var actions

    GlobalShortcut {
        appid: "solara"
        name: "launcher"
        description: "Open Solara launcher"

        onPressed: root.actions.openLauncher()
    }
}
