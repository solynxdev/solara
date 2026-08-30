import QtQuick
import Quickshell

import "../services"

Item {
    id: root

    required property var screen

    property int workspacesPerPage:
        ConfigManager.get("workspaces.count", 5)

    property bool showEmpty:
        ConfigManager.get("workspaces.showEmpty", false)

    WorkspaceModel {
        id: workspaceModel

        screen: root.screen
    }

    readonly property int activeIndex: {
        if (!workspaceModel.activeWorkspace)
            return 0;

        return workspaceModel.workspaces.values.indexOf(
            workspaceModel.activeWorkspace
        );
    }

    readonly property int pageStart:
        Math.floor(root.activeIndex / root.workspacesPerPage)
        * root.workspacesPerPage

    readonly property var visibleWorkspaces: ScriptModel {
        values: {
            const all = workspaceModel.workspaces.values;
            const start = root.pageStart;
            const end = start + root.workspacesPerPage;

            return all.filter((workspace, index) => {
                if (index < start || index >= end)
                    return false;

                return workspace.active ||
                        root.showEmpty ||
                        workspace.toplevels.values.length > 0;
            });
        }
    }

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    Row {
        id: layout

        anchors.centerIn: parent

        spacing: 4

        Repeater {
            model: root.visibleWorkspaces

            delegate: Workspace {
                required property var modelData

                workspace: modelData
                workspaceIndex: workspaceModel.workspaces.values.indexOf(modelData) + 1
            }
        }
    }
}
