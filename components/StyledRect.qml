/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Adapted from caelestia-dots/shell components/StyledRect.qml (GPL-3.0):
 * transparent surface with a standard Material colour morph.
 */

import QtQuick

Rectangle {
    id: root

    color: "transparent"

    Behavior on color {
        CAnim {}
    }
}