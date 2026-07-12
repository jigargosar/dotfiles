---
name: frontend-baseline
description: >
  Visual baseline for UI work — contrast, color,
  typography, hierarchy, target sizes, overflow,
  and interaction-state styling. The floor every
  UI must clear.
when_to_use: >
  Explicit asks: "audit the UI", "audit X for UI",
  "review this component", "check the styling",
  "look over this page", "do a UI pass on X", "UI
  review of X".


  Symptom reports: "UI is off", "looks off", "feels
  wrong", "doesn't look right", "needs polish",
  "looks janky", "hard to read", "too dim", "text
  too small", "barely visible", "tap target too
  small", "breaks the layout", "text overflows".


  Also any frontend/UI/CSS work — components,
  buttons, forms, modals, nav, color, contrast,
  typography, hierarchy, padding, overflow, hover,
  focus, icons, borders.
---

# frontend-baseline

Visual contrast and hierarchy floor that every UI must clear. Complements the `frontend-design` skill — frontend-design pushes the aesthetic ceiling; frontend-baseline enforces the floor. When one applies, the other usually does too.

## Floors

1. Your untuned default is too small, thin, low-contrast, and flat. Treat that first instinct as wrong: bias defaults toward larger, heavier, higher-contrast type and stronger hierarchy, and overshoot rather than hug your instinct.
2. You should treat WCAG AA as a floor to clear with margin, not a target, and AAA contrast as the goal.
3. You should judge contrast relative to type — smaller, thinner, or lighter text requires more — and you should prefer a perceptual check (APCA, as an Lc sanity layer) in addition to a WCAG-ratio measurement, over visual judgement.
4. Before treating any UI as done, you should compute and state, in your response, the contrast ratio and the level it clears for each of:
   1. Static — every text/background and icon/border pair at rest.
   2. Dynamic — every interaction state (hover, focus, active, selected); each must be visibly distinct from rest and itself clear the floor. Disabled is exempt from the floor but must remain perceptible (the 4c standard).
   3. Decoration — every non-text decorative element (borders, placeholders, faint icons) must be perceptible.
5. Encode hierarchy with two or more independent cues; each must still convey the level on its own if the others were removed. Size, weight, and color can each carry it alone; spacing generally cannot and does not count toward the two.
6. Never use `margin` — use `padding` instead. The only exception is `auto` margins for centering (`mx-auto`, etc.).
7. Interactive elements must have a target hit area of at least 24×24 CSS px (WCAG 2.2 SC 2.5.8, AA), with 44×44 CSS px as the goal (WCAG 2.2 SC 2.5.5, AAA). This applies to every interactive element regardless of type or visual size.
8. Interactive target backgrounds (hover, focus, selected) must not fuse with adjacent targets. The highlighted state must read as a discrete affordance — bound by visible separation (inset, rounded corners, gap) from its neighbors, not an edge-to-edge band that flows into them.
9. All rendered text must avoid horizontal overflow. **Tailwind v4.1+:** in flex/grid containers, use `wrap-anywhere` — it handles unbroken strings without needing `min-w-0` on the text item. Outside flex/grid, `wrap-break-word` is enough. For single-line cutoff use `truncate` or `line-clamp-N`. Both `wrap-break-word` and `truncate` silently fail inside flex/grid without `min-w-0`, which is why `wrap-anywhere` is the safer default there. **Caveat:** `overflow-wrap` (including `wrap-anywhere`) applies to text elements only — not `<input>` or replaced elements. Those still require `min-w-0` to shrink in flex/grid.
10. Layout must not shift when a scrollbar appears or disappears. Set `scrollbar-gutter: stable` on the page scroll root (Tailwind: `[scrollbar-gutter:stable]`), and on any container whose overflow state can toggle at runtime.
11. While a dialog/overlay is open, the background page must not scroll — not by mouse wheel, trackpad, or keyboard (arrows, PgUp/PgDn, Space, Home/End). Lock it (e.g. `overflow: hidden` on the scroll root; native `<dialog>.showModal()` or a scroll-lock utility). Per Floor 10, the lock itself must not shift layout when the scrollbar vanishes.
12. While a dialog/overlay is open, background content must be unreachable by focus: Tab must cycle only within the dialog, and no background control may be focusable or activatable (Enter/Space on a tabbed-to background button is a real action — that's the bug). Make the background subtree `inert` (native `<dialog>.showModal()` does this for free); a focus trap alone is the fallback, not the preference.

## Mitigation strategies

The contrast floor compresses foreground colors into a narrow band — color rarely carries hierarchy without violating the floor. Lean on these (not floor rules, just tactics that help):

1. Default to size and weight as the primary hierarchy cues; these survive any palette tightening. Three levels usually suffice — more layers confuse readers.
2. Vary type style within a single typeface (case, tracking, style) to add hierarchy layers without adding colors.
3. Keep the foreground palette small (2–3 text colors max). A tight palette reads as deliberate; a loose one reads as accidental.
4. Reserve 1–2 accent colors for state and emphasis (focus, selection, CTAs) — not for hierarchy.
5. Use elevation as a hierarchy carrier — shadows, tonal surfaces (lighter/darker shades of the base), subtle borders, or translucent layers. A 2–3 step elevation system with one consistent light direction gives most of the spatial benefit for zero perf cost.
6. Pair a distinctive display font with a refined body font; the contrast in form is itself a hierarchy cue.
7. Use whitespace to reinforce the read — more whitespace around an element raises its prominence (still supporting only, not a counted cue per Floors item 5).
