import QtQuick

QtObject {
    id: root

    signal launcherRequested()

    function openLauncher() {
        root.launcherRequested()
    }
}
