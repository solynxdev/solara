pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../launcher"
import "../../theme"
import "../../services"

Item {
    id: root

    property string query: ""
    property int selectedIndex: 0

    signal closed()
    signal commandRequested(string command)

    implicitWidth: 700
    implicitHeight: 500

    focus: true

    readonly property bool commandMode:
        root.query.startsWith(">")

    readonly property string searchQuery:
        root.commandMode
            ? root.query.slice(1).trim()
            : root.query.trim()

    readonly property string calcExpression:
        root.searchQuery.slice(4).trim()

    readonly property var calcValue:
        root.commandMode && root.searchQuery.startsWith("calc") && root.calcExpression
            ? root.evaluateExpr(root.calcExpression)
            : null

    readonly property var applications: ScriptModel {
        values: {
            const query = root.searchQuery.toLowerCase()
            const fuzzy = ConfigManager.get("launcher.fuzzy", true)
            const max = ConfigManager.get("launcher.maxResults", 15)
            const all = DesktopEntries.applications.values

            let list = []

            for (let i = 0; i < all.length; ++i) {
                const app = all[i]

                if (!query) {
                    list.push(app)
                } else if (fuzzy) {
                    const matches = root.fuzzyMatch(query, app.name)
                        || root.fuzzyMatch(query, app.genericName)
                        || root.fuzzyMatch(query, app.comment)
                        || app.keywords.some(
                            keyword => root.fuzzyMatch(query, keyword)
                        )

                    if (matches)
                        list.push(app)
                } else {
                    const matches = app.name.toLowerCase().includes(query)
                        || app.genericName.toLowerCase().includes(query)
                        || app.comment.toLowerCase().includes(query)
                        || app.keywords.some(
                            keyword => keyword.toLowerCase().includes(query)
                        )

                    if (matches)
                        list.push(app)
                }
            }

            if (query && fuzzy) {
                list.sort((a, b) =>
                    root.fuzzyCost(query, b, a) - root.fuzzyCost(query, a, b)
                )
            } else {
                list.sort((a, b) => a.name.localeCompare(b.name))
            }

            if (list.length > max)
                list.length = max

            return list
        }
    }

    readonly property var commands: {
        const list = []
        const query = root.searchQuery.toLowerCase()

        const pushPlain = (entry, keywords) => {
            if (!query || keywords.some(token => root.fuzzyMatch(query, token)))
                list.push(entry)
        }

        pushPlain(
            {
                id: "wallpaper",
                name: ">wallpaper",
                description: "Change your wallpaper",
                navigate: true,
                run: () => root.commandRequested("wallpaper")
            },
            ["wallpaper"]
        )

        pushPlain(
            {
                id: "scheme",
                name: ">scheme",
                description: "Change the current color scheme",
                navigate: true,
                run: () => root.commandRequested("scheme")
            },
            ["scheme"]
        )

        pushPlain(
            {
                id: "settings",
                name: ">settings",
                description: "Open Solara settings",
                navigate: true,
                run: () => root.commandRequested("settings")
            },
            ["settings"]
        )

        if (!query || root.fuzzyMatch(query, "calc")) {
            if (root.searchQuery.startsWith("calc")) {
                if (!root.calcExpression) {
                    list.unshift({
                        id: "calc-hint",
                        name: ">calc",
                        description: "e.g. 2 * (3 + 4)^2",
                        run: () => {
                            root.closed()
                        }
                    })
                } else if (root.calcValue !== null) {
                    list.unshift({
                        id: "calc",
                        name: ">calc = " + root.formatNumber(root.calcValue),
                        description: root.calcExpression + "  |  Enter copies to clipboard",
                        run: () => {
                            root.copyToClipboard(String(root.formatNumber(root.calcValue)))
                            root.closed()
                        }
                    })
                } else {
                    list.unshift({
                        id: "calc-error",
                        name: ">calc",
                        description: "Could not parse '" + root.calcExpression + "'",
                        run: () => {
                            root.closed()
                        }
                    })
                }
            }
        }

        const power = [
            {
                id: "power-lock",
                name: ">power lock",
                description: "Lock the screen",
                run: () => root.runProcess(["hyprlock"])
            },
            {
                id: "power-suspend",
                name: ">power suspend",
                description: "Suspend the system",
                run: () => root.runProcess(["systemctl", "suspend"])
            },
            {
                id: "power-reboot",
                name: ">power reboot",
                description: "Reboot the system",
                run: () => root.runProcess(["systemctl", "reboot"])
            },
            {
                id: "power-shutdown",
                name: ">power shutdown",
                description: "Power off the system",
                run: () => root.runProcess(["systemctl", "poweroff"])
            }
        ]

        for (const entry of power) {
            if (!query || root.fuzzyMatch(query, entry.name.slice(1)))
                list.push(entry)
        }

        return list
    }

    Rectangle {
        anchors.fill: parent

        radius: 24
        color: Theme.surface
    }

    Column {
        anchors {
            fill: parent
            margins: 20
        }

        spacing: 12

        Rectangle {
            id: searchBox

            width: parent.width
            height: 48

            radius: 14

            color: Qt.rgba(
                Theme.text.r,
                Theme.text.g,
                Theme.text.b,
                0.08
            )

            border {
                width: 1
                color: Qt.rgba(
                    Theme.text.r,
                    Theme.text.g,
                    Theme.text.b,
                    0.12
                )
            }

            Text {
                anchors {
                    left: parent.left
                    leftMargin: 14
                    verticalCenter: parent.verticalCenter
                }

                text: root.commandMode
                    ? "> "
                    : "Search applications..."

                color: Theme.textSecondary

                font.family: "JetBrains Mono"
                font.pixelSize: 14

                visible: !search.text
            }

            TextInput {
                id: search

                anchors {
                    fill: parent
                    leftMargin: 14
                    rightMargin: 14
                }

                color: Theme.text
                selectionColor: Qt.rgba(
                    Theme.text.r,
                    Theme.text.g,
                    Theme.text.b,
                    0.2
                )

                font.family: "JetBrains Mono"
                font.pixelSize: 18

                verticalAlignment: TextInput.AlignVCenter

                onTextChanged: {
                    root.query = text
                    root.selectedIndex = 0
                    results.currentIndex = 0
                }

                Keys.onPressed: event => {
                    switch (event.key) {
                    case Qt.Key_Up:
                        if (root.selectedIndex > 0)
                            root.selectedIndex--

                        event.accepted = true
                        break

                    case Qt.Key_Down:
                        if (root.selectedIndex < results.count - 1)
                            root.selectedIndex++

                        event.accepted = true
                        break

                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                        results.currentItem?.activate()
                        event.accepted = true
                        break

                    case Qt.Key_Escape:
                        root.closed()
                        event.accepted = true
                        break
                    }
                }

                onVisibleChanged: {
                    if (visible)
                        Qt.callLater(() => search.forceActiveFocus())
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1

            color: Qt.rgba(
                Theme.text.r,
                Theme.text.g,
                Theme.text.b,
                0.15
            )
        }

        ListView {
            id: results

            width: parent.width
            height: parent.height - searchBox.height - 13

            currentIndex: root.selectedIndex

            clip: true
            spacing: 6

            model: root.commandMode
                ? root.commands
                : root.applications

            delegate: Item {
                id: delegateRoot

                required property var modelData

                width: results.width
                height: 64

                function activate() {
                    if (root.commandMode) {
                        modelData.run()

                        if (!modelData.navigate)
                            root.closed()
                    } else {
                        appEntry.activate()
                    }
                }

                LauncherApp {
                    id: appEntry

                    anchors.fill: parent

                    visible: !root.commandMode
                    app: delegateRoot.modelData

                    onLaunched: root.closed()
                }

                LauncherCommand {
                    anchors.fill: parent

                    visible: root.commandMode
                    command: delegateRoot.modelData

                    onTriggered: {
                        modelData.run()

                        if (!modelData.navigate)
                            root.closed()
                    }
                }
            }

            onCurrentIndexChanged: {
                root.selectedIndex = currentIndex
            }
        }
    }

    Process {
        id: runner

        onExited: (exitCode, exitStatus) => {
            root.closed()
        }
    }

    function runProcess(argv) {
        runner.command = argv
        runner.running = false
        runner.running = true
    }

    function copyToClipboard(text) {
        const safe = "'" + text.replace(/'/g, "'\\''") + "'"

        runner.command = ["sh", "-c", "printf %s " + safe + " | wl-copy", "solara"]
        runner.running = false
        runner.running = true
    }

    function fuzzyMatch(needle, haystack) {
        const n = needle.toLowerCase()
        const h = String(haystack || "").toLowerCase()

        if (!n)
            return true

        if (h.includes(n))
            return true

        let matched = 0

        for (let j = 0; j < h.length; ++j) {
            if (h[j] === n[matched])
                matched++

            if (matched === n.length)
                return true
        }

        return false
    }

    function fuzzyCost(needle, a, b) {
        const sources = [
            a.name, a.genericName, a.comment
        ].concat(a.keywords || [])

        const targets = [
            b.name, b.genericName, b.comment
        ].concat(b.keywords || [])

        return root.bestCost(needle, sources) - root.bestCost(needle, targets)
    }

    function bestCost(needle, sources) {
        let best = -1

        const n = needle.toLowerCase()

        for (const source of sources) {
            const h = String(source || "").toLowerCase()

            if (!h)
                continue

            const direct = h.indexOf(n)

            if (direct >= 0) {
                const candidate = 1000 - direct
                if (candidate > best)
                    best = candidate
                continue
            }

            let matched = 0
            let score = 0
            let streak = 0
            let previous = -2

            for (let j = 0; j < h.length; ++j) {
                if (h[j] === n[matched]) {
                    streak = j === previous + 1 ? streak + 1 : 0
                    score += 10 + streak * 5
                    previous = j
                    matched++

                    if (matched === n.length)
                        break
                }
            }

            if (matched === n.length && score > best)
                best = score
        }

        return best
    }

    function formatNumber(value) {
        if (Math.abs(value) < 1e9 && Math.abs(value) >= 1e-6) {
            return String(Math.round(value * 1000) / 1000)
        }

        return value.toExponential(3)
    }

    function evaluateExpr(raw) {
        const src = String(raw).trim()

        if (!src)
            return null

        let pos = 0

        function isDigit(c) {
            return c !== undefined && c >= "0" && c <= "9"
        }

        function skip() {
            while (src[pos] === " ")
                pos++
        }

        function peek() {
            skip()
            return src[pos]
        }

        function parseNumber() {
            skip()

            const start = pos

            while (isDigit(src[pos]) || src[pos] === ".")
                pos++

            if (pos === start)
                throw new Error("failed")

            return Number(src.slice(start, pos))
        }

        function parseUnary() {
            if (peek() === "-") {
                pos++
                return -parseUnary()
            }

            if (peek() === "+") {
                pos++
                return parseUnary()
            }

            if (peek() === "(") {
                pos++
                const value = parseAdd()
                if (peek() !== ")")
                    throw new Error("failed")
                pos++
                return value
            }

            if (src.slice(pos, pos + 2) === "pi") {
                pos += 2
                return Math.PI
            }

            if (src[pos] === "e") {
                pos++
                return Math.E
            }

            return parseNumber()
        }

        function parsePower() {
            let value = parseUnary()

            if (peek() === "^") {
                pos++
                value = Math.pow(value, parsePower())
            }

            return value
        }

        function parseTerm() {
            let value = parsePower()

            while (true) {
                const op = peek()

                if (op === "*" || op === "/" || op === "%") {
                    pos++
                    const right = parsePower()

                    if (op === "*")
                        value *= right
                    else if (op === "/")
                        value /= right
                    else
                        value %= right
                } else {
                    return value
                }
            }
        }

        function parseAdd() {
            let value = parseTerm()

            while (true) {
                const op = peek()

                if (op === "+" || op === "-") {
                    pos++
                    const right = parseTerm()

                    if (op === "+")
                        value += right
                    else
                        value -= right
                } else {
                    return value
                }
            }
        }

        try {
            const result = parseAdd()

            if (pos < src.length)
                return null

            if (!Number.isFinite(result))
                return null

            return result
        } catch (error) {
            return null
        }
    }

    onEnabledChanged: {
        if (!enabled)
            return

        root.query = ""
        root.selectedIndex = 0

        search.text = ""
        results.currentIndex = 0

        Qt.callLater(() => search.forceActiveFocus())
    }
}