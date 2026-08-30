import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string wallpaperDirectory:
        Quickshell.env("HOME") + "/Pictures/Wallpapers"

    property var wallpapers: []

    Process {
        id: scanner

        command: [
            "find",
            root.wallpaperDirectory,
            "-maxdepth", "1",
            "-type", "f",
            "(",
                "-iname", "*.png",
                "-o",
                "-iname", "*.jpg",
                "-o",
                "-iname", "*.jpeg",
                "-o",
                "-iname", "*.webp",
            ")",
            "-print"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim()

                if (!output) {
                    root.wallpapers = []
                    return
                }

                root.wallpapers = output
                    .split("\n")
                    .filter(path => path.length > 0)
                    .sort()
                    .map(path => ({
                        path: path,
                        name: path.substring(path.lastIndexOf("/") + 1)
                    }))
            }
        }
    }

    function refresh() {
        scanner.running = false
        scanner.running = true
    }

    Component.onCompleted: {
        refresh()
    }
}
