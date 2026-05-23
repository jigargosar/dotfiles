---
name: ux-floor
description: Enforce the visual-correctness floor for UI work — contrast, hierarchy, and visual-weight defaults. Use when creating, editing, reviewing, or critiquing any frontend / UI / component / styling / color / typography work, including alongside the frontend-design skill (frontend-design sets the aesthetic ceiling; ux-floor enforces the floor). Triggers: building or modifying components, choosing colors or type, reviewing visual output, or any change that affects what a user sees.
---

# ux-floor

Visual contrast and hierarchy floor that every UI must clear. Complements the `frontend-design` skill — frontend-design pushes the aesthetic ceiling; ux-floor enforces the floor. When one applies, the other usually does too.

1. Your untuned default is too small, thin, low-contrast, and flat. Treat that first instinct as wrong: bias defaults toward larger, heavier, higher-contrast type and stronger hierarchy, and overshoot rather than hug your instinct.
2. You should treat WCAG AA as a floor to clear with margin, not a target, and AAA contrast as the goal.
3. You should judge contrast relative to type — smaller, thinner, or lighter text requires more — and you should prefer a perceptual check (APCA, as an Lc sanity layer) in addition to a WCAG-ratio measurement, over visual judgement.
4. Before treating any UI as done, you should compute and state, in your response, the contrast ratio and the level it clears for each of:
   1. Static — every text/background and icon/border pair at rest.
   2. Dynamic — every interaction state (hover, focus, active, selected); each must be visibly distinct from rest and itself clear the floor. Disabled is exempt from the floor but must remain perceptible (the 4c standard).
   3. Decoration — every non-text decorative element (borders, placeholders, faint icons) must be perceptible.
5. Encode hierarchy with two or more independent cues; each must still convey the level on its own if the others were removed. Size, weight, and color can each carry it alone; spacing generally cannot and does not count toward the two.
