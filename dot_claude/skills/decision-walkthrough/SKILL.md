---
name: decision-walkthrough
description: Re-present a set of options, questions, or decisions from your previous response and walk the user through them ONE AT A TIME, each with context, options, and a recommendation, pausing for the user's answer before continuing. Use this whenever the user wants to go through choices/questions/open decisions sequentially rather than all at once — triggers include "go through these one at a time", "walk me through the options", "present these decisions one by one", "re-present the questions", "let's tackle these individually", or any request to slow down and decide item-by-item after you've offered several options or asked several questions.
user-invocable: true
disable-model-invocation: true
---

# Decision Walkthrough

Re-present the options, questions, or decisions from your last response (or another agreed-upon set) and guide the user through them sequentially. The goal is to turn a wall of choices into a focused, one-decision-at-a-time conversation where each item is framed well enough for the user to decide confidently.

## Identify the item set

Determine which items to walk through:

1. Default to the options/questions from your immediately preceding response.
2. If the user points to a different source (an earlier message, a list, a document), use that instead.
3. If it's ambiguous which set they mean, ask once before starting.

## Present ONE item at a time

Present a single item, then stop and wait. Never batch multiple items into one turn. Each presentation MUST include all three of:

1. **Context** — why this decision matters. What depends on it, what it affects downstream, why it's worth the user's attention. Keep it tight; a sentence or two is usually enough.
2. **Options** — the choices available for this item, stated clearly and distinctly so they're genuinely comparable.
3. **Recommendation with reasoning** — your recommendation and the honest reasons for it. If you truly have no preference, say so and explain why, rather than manufacturing one.

## Output formatting rule

All items and their options use serial, continuous numbering — never bullets or dashes. Numbering runs continuously across the entire response: if you present item 3 with four options, those options are numbered within the item, and the item headers themselves stay sequential (Item 1, Item 2, ...). Use numbered sublists, not bulleted ones, anywhere nested structure is needed. This keeps every choice individually referenceable ("I'll take option 2 on item 3").

## Wait, then track progress

After presenting an item:

1. Stop and wait for the user's response. Do not move to the next item, and do not pre-write later items.
2. Once they respond, acknowledge their decision briefly, then move to the next item.
3. If items remain, state how many are left (e.g., "3 remaining"). This gives the user a sense of pace and lets them stop early if they want.
4. When the last item is done, give a short recap of the decisions made across all items.

## Format

Use this structure per item:

```
**Item N of TOTAL — [short label]**

Context: [why this matters]

Options:
1. [option one]
2. [option two]

Recommendation: [your pick] — [reasoning]
```

Then wait for the user.

## Example

Suppose the prior response offered three open choices about a deployment. The walkthrough would proceed:

```
**Item 1 of 3 — Hosting provider**

Context: This locks in your pricing model and the migration effort for
everything downstream, so it's the hardest to reverse later.

Options:
1. Managed platform (higher cost, near-zero ops)
2. Self-managed VMs (lower cost, you own uptime)

Recommendation: Managed platform — your team is small and the ops time
saved outweighs the price gap at your current scale.

[wait for user; after they answer:]

Got it, managed platform. 2 remaining.

**Item 2 of 3 — ...**
```