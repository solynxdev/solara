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
    id: root

    property int type: -1

    duration: root.type >= 0
        ? root.durationOf(root.type)
        : AnimationManager.indicator.duration
    easing.type: root.type >= 0
        ? root.easingOf(root.type)
        : AnimationManager.easing.standard

    function durationOf(type) {
        switch (type) {
        case Anim.FastSpatial:
        case Anim.StandardSmall:
        case Anim.EmphasizedSmall:
            return AnimationManager.timings.fast
        case Anim.DefaultSpatial:
        case Anim.FastEffects:
            return AnimationManager.content.duration
        case Anim.SlowSpatial:
        case Anim.StandardLarge:
        case Anim.EmphasizedLarge:
            return AnimationManager.timings.slow
        case Anim.DefaultEffects:
            return AnimationManager.panel.duration
        case Anim.SlowEffects:
        case Anim.StandardExtraLarge:
        case Anim.EmphasizedExtraLarge:
            return AnimationManager.timings.verySlow
        default:
            return AnimationManager.timings.normal
        }
    }

    function easingOf(type) {
        switch (type) {
        case Anim.EmphasizedSmall:
        case Anim.Emphasized:
        case Anim.EmphasizedLarge:
        case Anim.EmphasizedExtraLarge:
            return AnimationManager.easing.emphasized
        default:
            return AnimationManager.easing.standard
        }
    }
}