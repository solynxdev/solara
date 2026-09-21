# Third-Party Notices & Attribution

This project (Solara) is licensed under the GNU General Public License v3.0 —
see `LICENSE` in this directory.

This document is an engineering-level provenance/attribution log produced
during the Material You redesign (P0 licensing gate). It records, for each
external source that informs this codebase, the project, its license, how
Solara uses it, and what obligations apply. **It is not legal advice.** When
in doubt about a specific file, treat the source project's own license text
as authoritative.

## Status modes

| Mode           | Meaning                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------ |
| `DERIVED`      | Code is adapted/reworked from the named source. GPL copyleft applies to the combined work; a license header + attribution comment is required on the resulting Solara file. |
| `PATTERN`      | The named source informed design/architecture; no contiguous lines copied. Attribution comment recommended; header not strictly required. |
| `REFERENCE-ONLY` | Consulted for behavior; intentionally **not copied** (license ambiguity or poor architectural fit). |
| `VENDORED`     | Copied near-verbatim. Upstream license text must be preserved with the file and listed here.     |

## Upstream sources

| Project | URL | License | Role in Solara |
| ------- | --- | ------- | -------------- |
| Caelestia | https://github.com/caelestia-dots/shell | GPL-3.0 | Controls, tokens, anim primitives, bar/popout patterns |
| end-4 / dots-hyprland (local tree: `~/.config/quickshell/ii`) | https://github.com/end-4/dots-hyprland | GPL-3.0 | Theme loader pattern, tray, popups, services, notifications/OSD (Category B) |
| nixnew (outfoxxed) | https://git.outfoxxed.me/outfoxxed/nixnew | no license; author OK with redistribution (per source header) | Media source of the Quickshell Mpris service idea — **REFERENCE-ONLY** |
| material-shapes (vendored inside end-4) | (part of end-4 tree) | Apache-2.0 | Notch/corner morph shapes (Category B) |
| matugen (InioX) | https://github.com/InioX/matugen | GPL-2.0 | External CLI tool for dynamic color (invoked, not vendored) |
| Quickshell (outfoxxed) | https://github.com/outfoxxed/quickshell | LGPL-3.0+ (framework + plugin variants) | Framework/API only; no code copied |
| Caffyne | (Battery/other widget sources in some dotfiles) | AGPL-3.0 | **EXCLUDED — do not adapt** |

## Adaptation graph (files to be created during implementation)

| Phase | Resulting Solara file(s) | Derived from | Mode / license | Header required |
| ----- | ------------------------ | ------------ | -------------- | --------------- |
| P1 | `theme/Theme.qml` (role rewrite) | Solara original | authored, GPL-3.0 | no external attribution |
| P1 | `theme/ThemeManager.qml` (static M3 scheme loading) | `ii/services/MaterialThemeLoader.qml` (FileView pattern) | `DERIVED` GPL-3.0 | derived-from comment |
| P1 | `services/ColorManager.qml` | `ii/services/MaterialThemeLoader.qml` | `DERIVED` GPL-3.0 | header + derived-from comment |
| P2 | tokens (no new file) | Caelestia token semantics folded into existing `services/AnimationManager.qml` (Solara-original) | `PATTERN` GPL-3.0 | attribution comment |
| P2 | `components/{Anim,CAnim,AnimLoader,StyledRect}.qml` | Caelestia `components/*.qml` | `DERIVED` GPL-3.0 | header |
| P2 | `components/StateLayer.qml` | Caelestia `components/StateLayer.qml` | `DERIVED` GPL-3.0 | header |
| P2 | `components/controls/ButtonBase.qml` | Caelestia `components/controls/ButtonBase.qml` | `DERIVED` GPL-3.0 | header |
| P5 | `surfaces/bar/…` entries layer | Caelestia `modules/bar/Bar.qml` (pattern only — no sidebar transplant) | `PATTERN` GPL-3.0 | attribution comment |
| P6 | `services/ShellState.qml` | Caelestia `modules/bar/popouts/PopoutState.qml` + `ii/GlobalStates.qml` (idioms) | `PATTERN` GPL-3.0 | attribution comment |
| P6 | `surfaces/popups/…` | `ii/modules/waffle/bar/BarPopup.qml`, `ii/modules/waffle/looks/WBarAttachedPanelContent.qml` | `PATTERN`/`DERIVED` GPL-3.0 | header |
| P7 | `services/{Audio,Brightness,Notifications,Network,TrayService}.qml` | `ii/services/*.qml` | `DERIVED` GPL-3.0 | header (Brightness/Network already credit Caelestia GPL-3.0 upstream) |
| P7 | notification popups / OSD / action-center-lite | `ii/modules/waffle/{notificationPopup,onScreenDisplay,actionCenter}/*` | `DERIVED` GPL-3.0 | header |
| P7 | media / controls panes | `ii/modules/waffle/actionCenter/MediaPaneContent.qml` et al. | `DERIVED` GPL-3.0 | header |
| B | morph shapes (notch corners) | material-shapes (Apache-2.0) | `VENDORED` Apache-2.0 | preserve upstream header + LICENSE |
| P7 | Wallpapers service | `ii/services/Wallpapers.qml` | `DERIVED` GPL-3.0 | header |

## VERIFY BEFORE COPY — resolution status (P0)

1. **`ii/services/MprisController.qml`** — RESOLVED. Header states: from `nixnew`, "does not have a license, but the author is okay with redistribution." Decision: **REFERENCE-ONLY** — do not copy; implement media via the Quickshell `Quickshell.Services.Mpris` plugin, which is already the API the Quickshell framework provides. No further action needed.
2. **`ii/services/MaterialThemeLoader.qml`** — RESOLVED. No per-file header; the whole ii tree is GPL-3.0. Confirmed: `FileView` + `JSON.parse` + snake_case→CamelCase assignment + keep-last-good on parse failure. Safe to derive under GPL-3.0.
3. **`ii/modules/waffle/actionCenter/MediaPaneContent.qml`** — RESOLVED. No header; ii GPL-3.0; imports are looks/services/common only. Derivations OK; read in full at P7 before adapting.
4. **`ii/scripts/colors/*.py`** — RESOLVED. No headers; ii GPL-3.0. Not needed for P0–P6. The dynamic path is covered by matugen + the `colors.json` template; revisit at P4 only if the optional auto-luminance path is adopted. Otherwise REFERENCE-ONLY.
5. **`BarPopup.qml` / `WBarAttachedPanelContent.qml` / `TrayOverflowMenu.qml` / `WaffleNotificationPopup.qml`** — RESOLVED. No headers; ii GPL-3.0. Imports confirmed to be looks/services/common (+ `Qt5Compat.GraphicalEffects` on two); no foreign-tree dependency (no walnut/quilt/smesh/etc.). Derivations OK with GPL-3.0 header.
6. **matugen LICENSE** — RESOLVED. Full GPL-2.0 text verified at the matugen repository. matugen is an external CLI tool (invoked from ColorManager in dynamic mode), not vendored or linked, so Solara's GPL-3.0 is unaffected. RESOLVED-AT-P4: matugen 4.2.0 is now installed; dynamic mode runs `matugen -c solara/matugen/config.toml image --source-color-index 0 <wallpaper>`, rendering the repo-contained 51-role template into the watched colors file. If matugen is ever absent again, ColorManager keeps the last valid palette and warns once.
7. **Caelestia `modules/bar/popouts/Wrapper.qml`** — RESOLVED (audit). Imports sidebar-specific modules (`qs.modules.nexus`, `qs.modules.windowinfo`, `QsWindow.window`). Marked REFERENCE-ONLY pattern; the body is not copied (staged P5 bar design keeps Solara's two existing bar windows).
8. **Caelestia `Elevation`** — RESOLVED. No such component exists in Caelestia; the earlier plan reference is corrected. M3 elevation is expressed via tokens + surface colors + optional drop shadow (`Qt5Compat.GraphicalEffects.DropShadow` or Qt Quick Effects).

## Externally invoked tools (runtime/system, not copied)

- **Quickshell** (outfoxxed) — LGPL-3.0+ framework; QML import API only.
- **matugen** — GPL-2.0; invoked as a CLI by `ColorManager` only in dynamic scheme mode.
- **nmcli / NetworkManager** — GPL-2.0+; may be invoked by the Network service, or the `Quickshell.Networking` plugin is used instead.
- **Hyprland / hyprctl** — BSD-3-Clause; runtime compositor.
- **Material Symbols Rounded** — Apache-2.0; icon glyph asset only.

## New Solara source file header template

Every adapted/derived file created in this implementation carries this header,
with `P0 date` set to `2026-09-20`:

```
/*
 * SPDX-License-Identifier: GPL-3.0
 * SPDX-FileCopyrightText: 2026 Solara contributors
 *
 * Derived from <project URL> (GPL-3.0): <summary of what changed>.
 */
```

Vendored Apache-2.0 material-shapes files instead keep their original
Apache-2.0 header plus an `SPDX-License-Identifier: Apache-2.0` tag; the
upstream LICENSE text is preserved alongside.

## Implementation log

| Date      | Commit | Phase | Summary |
| --------- | ------ | ----- | ------- |
| 2026-09-20 | `d0646ef` | P0 | Canonical GPL-3.0 `LICENSE` + this attribution document added. |
| 2026-09-20 | `71d324f` | P1 | M3 roles pipeline: scheme JSON role sets (light/dark), FileView-based ThemeManager + ColorManager, Theme role surface, `theme.mode` config + Settings control. |
| 2026-09-20 | `04f0b42` | P2 | `components/{Anim,CAnim,AnimLoader,StyledRect,StateLayer}.qml` + `components/controls/ButtonBase.qml` adapted (GPL-3.0); color morphs across surfaces/controls switched to `CAnim` (reduced-motion aware). |
| 2026-09-20 | `e261071` | P2 | Runtime smoke-test fixes: `ColorManager` qmldir registration + duplicate `rolesChanged` removal, FileView default path, missing `components` import, Anim/CAnim literal-type scope (id: root). |
| 2026-09-20 | `aa21dd8` | P3 | Controls adopt `ButtonBase`: SegmentedControl text segments, notch ToggleButton/ActionChip (tonal), workspace `StateLayer` pills; ad-hoc literals retargeted to M3 roles (hover rows, toggle/slider tracks, workspace dots). |
| 2026-09-20 | `ba7c498` | P3 | THIRD_PARTY implementation-log housekeeping (real SHAs). |
| 2026-09-20 | `(P4)` | P4 | Dynamic colors: matugen installed; repo-contained `matugen/{config.toml,templates/colors.json}` renders the 51 M3 roles; ColorManager spawns matugen (Process via `running`), attaches its FileView only once the generated file exists, regenerates on wallpaper/scheme change; verified end-to-end with a clean log. |

## Preexisting status note

Solara previously had no LICENSE and no per-file provenance headers. Pursuant
to this document, all Solara-authored files are covered by `LICENSE`
(GPL-3.0). Theme scheme JSON files (`schemes/**/*.json`), `config.json`, and
generated artifacts are factual data and are not separately attributed.