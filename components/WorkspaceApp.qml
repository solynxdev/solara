import QtQuick
import Quickshell

Item {
    id: root

    required property var toplevel
    required property var size

    width: size
    height: size

    y: 0

    readonly property string appId:
        root.toplevel.wayland?.appId ?? ""

    readonly property var desktopEntry: {
        const appId = root.appId.toLowerCase();

        return DesktopEntries.applications.values.find(entry => {
            const id = (entry.id ?? "").toLowerCase();
            const startupClass = (entry.startupClass ?? "").toLowerCase();

            return id === appId ||
                    startupClass === appId;
        }) ?? null;
    }

    Image {
        anchors.fill: parent

        source: root.desktopEntry
            ? Quickshell.iconPath(root.desktopEntry.icon)
            : ""

        fillMode: Image.PreserveAspectFit
        smooth: true
    }
}
