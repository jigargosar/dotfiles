---
name: fresh-eyes-fix
description: Map reading pain points to fix patterns — repeated boilerplate, mixed responsibilities, names before context. Use after /fresh-eyes-review once pains are agreed on.
argument-hint: "[file-path]"
allowed-tools: Read, Glob, Grep
---

# Fix Reading Pain

Map agreed-upon pain points from a fresh-eyes review to concrete fix patterns. This skill assumes pain points have already been identified and discussed.

## Prerequisite

A `/fresh-eyes-review` has been run and the user has agreed on which pain points matter. If no prior review exists in the conversation, ask the user to run `/fresh-eyes-review` first.

## Pain-to-Pattern Taxonomy

For each agreed pain point, identify which category it falls into and propose the corresponding fix:

### 1. Repeated boilerplate
**Symptom:** Same structural shape appears multiple times with different inner logic.
**Diagnostic:** "Am I reading past the same shape to find different guts?"
**Pattern:** Separation of mechanism and policy — abstract the repeated shell into a reusable primitive, keep the logic inline and visible.
**Example:** Two `useEffect` blocks both doing `addEventListener` + cleanup with different callbacks → extract `useEventListener` primitive.

### 2. Mixed responsibilities
**Symptom:** Two unrelated behaviors behind one name, early return splits the function into hidden halves.
**Diagnostic:** "Does this function do two things I'd describe differently?"
**Pattern:** Split the function. If the split is pure logic vs side effects, use functional core / imperative shell.
**Example:** `handleCanvasPointerDown` that does tool placement OR pan start → separate tool dispatch from default canvas behavior.

### 3. Names before context
**Symptom:** Information presented before the reader has any reason to care about it.
**Diagnostic:** "Am I holding names with no idea when they'll pay off?"
**Pattern:** Proximity — colocate names with usage. At file level, newspaper style (exports first, helpers below).
**Example:** Eleven store values destructured at the top of a hook before any logic uses them → push groups into sub-hooks that own their subscriptions.

## Method

1. List the agreed pain points from the prior review
2. For each pain point, identify its category from the taxonomy above
3. Propose a concrete fix using the corresponding pattern, with specifics from the actual code
4. Discuss each fix inline — the user may accept, reject, or refine
5. After agreement, present an implementation plan

## What NOT to do

- Don't re-diagnose — the pain points are already agreed on
- Don't propose fixes for pains the user didn't agree with
- Don't apply patterns mechanically — explain why this pattern fits this specific pain
- Don't skip the discussion — each fix should be talked through before implementing
