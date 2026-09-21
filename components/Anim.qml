/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Adapted from caelestia-dots/shell components/Anim.qml (GPL-3.0):
 * Material motion design tokens mapped onto Solara's AnimationManager so
 * every motion honours the global animations.enabled / reduced-motion toggle.
 */

import QtQuick

import "../services"

NumberAnimation {
    id: root

    enum Type {
        StandardSmall = 0,
        Standard,
        StandardLarge,
        StandardExtraLarge,
        EmphasizedSmall,
        Emphasized,
        EmphasizedLarge,
        EmphasizedExtraLarge,
        FastSpatial,
        DefaultSpatial,
        SlowSpatial,
        FastEffects,
        DefaultEffects,
        SlowEffects
    }

    property int type: Anim.DefaultSpatial

    duration: root.durationOf(root.type)
    easing.type: root.easingOf(root.type)

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