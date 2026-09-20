/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Adapted from caelestia-dots/shell components/CAnim.qml (GPL-3.0):
 * Material colour-morph animation. Defaults reproduce Solara's standard
 * indicator morph (respecting reduced motion); pass an Anim.Type to pick
 * the same tokens Anim uses.
 */

import QtQuick

import "../services"

ColorAnimation {
    property int type: -1

    duration: root.type >= 0
        ? Anim.durationOf(root.type)
        : AnimationManager.indicator.duration
    easing.type: root.type >= 0
        ? Anim.easingOf(root.type)
        : AnimationManager.easing.standard
}