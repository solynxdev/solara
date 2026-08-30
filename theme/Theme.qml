pragma Singleton

import QtQuick

import "../services"

QtObject {
    id: root

    readonly property string fontFamily: "Sans"
    readonly property string notchStyle: ConfigManager.get("notch.style", "chrome")
    readonly property color background: ThemeManager.color("background", "#1e1e2e")
    readonly property color chrome: root.notchStyle === "monitor" ? "#000000" : ThemeManager.color("chrome", "#11111b")
    readonly property color surface: ThemeManager.color("surface", "#181825")
    readonly property color surfaceVariant: ThemeManager.color("surfaceVariant", "#313244")
    readonly property color text: ThemeManager.color("text", "#cdd6f4")
    readonly property color textSecondary: ThemeManager.color("textSecondary", "#bac2de")
    readonly property color accent: ThemeManager.color("accent", "#cba6f7")
    readonly property color accentText: ThemeManager.color("accentText", "#1e1e2e")
    readonly property color border: ThemeManager.color("border", "#45475a")
    readonly property color red: ThemeManager.color("red", "#f38ba8")
    readonly property color green: ThemeManager.color("green", "#a6e3a1")
    readonly property color yellow: ThemeManager.color("yellow", "#f9e2af")
    readonly property color blue: ThemeManager.color("blue", "#89b4fa")
    readonly property color purple: ThemeManager.color("purple", "#cba6f7")
    readonly property color cyan: ThemeManager.color("cyan", "#94e2d5")
    readonly property color overlay: ThemeManager.color("overlay", "#6c7086")
    readonly property color selection: ThemeManager.color("selection", "#45475a")
    readonly property color shadow: ThemeManager.color("shadow", "#11111b")
}
