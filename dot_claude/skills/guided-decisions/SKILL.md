---
name: guided-decisions
description: >-
  Re-present the options/questions/decisions from the previous response
  (or a named source), one item at a time, each with context, clearly
  stated options, and a recommendation with reasoning — pausing for the
  user's answer before continuing. Merges the /present slash-command
  workflow with the decision-walkthrough structure.
when_to_use: >-
  When the user explicitly types /guided-decisions, optionally with
  arguments naming the source; otherwise re-presents the last response's
  options/questions/decisions. Manual invocation only — this skill does
  not auto-trigger.
user-invocable: true
disable-model-invocation: true
---

# Guided Decisions

Re-present options/questions/decisions, one at a time, with enough framing that each one can be decided confidently.

## Determine the source

1. If arguments were passed to /guided-decisions, treat them as the source.
2. Otherwise, use the options/questions/decisions from the last response.
3. If it's ambiguous which set is meant, ask once before starting.

## Present ONE item at a time

Present a single item, then stop and wait. Never batch multiple items into one turn, and never pre-write later items. Each presentation MUST include:

1. **Item** — the option/question, stated clearly (quote the original wording where it matters, rather than a lossy paraphrase).
2. **Context** — why this item matters: what depends on it, what it affects downstream.
3. **Options** — the choices available, stated distinctly and comparably.
4. **Recommendation with reasoning** — your pick and the honest reasons for it. If you have no real preference, say so rather than manufacturing one.

## Formatting rule

All items and their options use serial, continuous numbering — never bullets or dashes. Numbering runs continuously across the entire response: item headers stay sequential (Item 1, Item 2, ...), and any options nested under an item are numbered within it. This keeps every choice individually referenceable ("I'll take option 2 on item 3").

Use this structure per item:

```
**Item N of TOTAL — [short label]**

Item: [item, quoted/stated clearly]

Context: [why this matters]

Options:
1. [option one]
2. [option two]

Recommendation: [your pick] — [reasoning]
```

## Wait, then track progress

After presenting an item:

1. Stop and wait for the user's response.
2. If the user replies "next" (or similar) without a clear decision, treat that as accepting the stated recommendation.
3. Acknowledge the decision briefly, then move to the next item.
4. State how many items remain (e.g., "3 remaining"), so the user can gauge pace and stop early if they want. Use judgment on how much detail to show here.
5. When the last item is done, give a short recap of the decisions made across all items.