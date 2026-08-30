import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: root

    required property var screen

    readonly property var monitor: Hyprland.monitorFor(root.screen)

    readonly property var workspaces: ScriptModel {
        values: {
            if (!root.monitor)
                return [];

            return Hyprland.workspaces.values
                .filter(workspace =>
                    workspace.monitor === root.monitor &&
                    workspace.id > 0
                )
                .sort((a, b) => a.id - b.id);
        }
    }

    readonly property var activeWorkspace: {
        if (!root.monitor)
            return null;

        return root.workspaces.values.find(
            workspace => workspace.active
        ) ?? null;
    }
}
