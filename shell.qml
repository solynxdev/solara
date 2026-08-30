pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

import "surfaces"
import "surfaces/wallpaper"

import "components"
import "services"

ShellRoot {
    id: shell

    Actions {
        id: actions

        onLauncherRequested: {
            const focusedMonitor = Hyprland.focusedMonitor

            if (!focusedMonitor)
                return

            for (const screen of Quickshell.screens) {
                const monitor = Hyprland.monitorFor(screen)

                if (monitor === focusedMonitor) {
                    for (const notch of notchInstances) {
                        if (notch.screen === screen)
                            notch.mode = "launcher"
                    }

                    break
                }
            }
        }
    }

    GlobalShortcuts {
        actions: actions
    }

    property var notchInstances: []

    Variants {
        model: Quickshell.screens

        delegate: Item {
            id: root

            required property var modelData

            focus: true

            Component.onCompleted: {
                shell.notchInstances.push(notch)
            }

            Component.onDestruction: {
                const index = shell.notchInstances.indexOf(notch)

                if (index !== -1)
                    shell.notchInstances.splice(index, 1)
            }

            ScreenCorners {
                screen: root.modelData
            }

            WallpaperWindow {
                targetScreen: root.modelData
                wallpaperPath: WallpaperManager.currentPath
                visible: WallpaperManager.currentPath !== ""
            }

            Item {
                Bar {
                    id: workspaceBar

                    screen: root.modelData

                    visible: ConfigManager.get("bar.enabled", true)

                    anchors {
                        left: true
                    }

                    margins {
                        left: (root.modelData.width - notch.contentWidth)
                            / 2
                            - workspaceBar.width
                            - 6
                    }

                    Workspaces {
                        id: workspaces

                        screen: root.modelData
                    }
                }

                Bar {
                    id: controlBar

                    screen: root.modelData

                    visible: ConfigManager.get("bar.enabled", true)

                    anchors {
                        right: true
                    }

                    margins {
                        right: (root.modelData.width - notch.contentWidth)
                            / 2
                            - controlBar.width
                            - 6
                    }

                    ControlCenter {
                        anchors.centerIn: parent
                    }
                }

                Notch {
                    id: notch

                    screen: root.modelData
                }
            }

            PanelWindow {
                anchors {
                    top: true
                    left: true
                    right: true
                }

                mask: Region {}

                color: "transparent"

                implicitHeight: 36

                screen: root.modelData
            }
        }
    }
}
