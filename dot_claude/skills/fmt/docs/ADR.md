# ADR: Critical Step checklist — redundancy review

## Status

Recorded. No items merged or removed from SKILL.md's checklist. A condensed
pointer to this document also lives at the end of SKILL.md.

## Context

The "Critical Step" self-check list in SKILL.md grew from 9 to 17+ items
through iterative manual edits. A review pass found several items
describing the same underlying issue in different words.

## Redundant clusters identified (not merged)

1. Problem-inventing: "Provides solutions to problems that never existed",
   "Invents problems", "Narrates why a solution is invalid for a problem
   that never existed" — same concept, 3 phrasings.
2. History: "Narrates parts of conversation", "Re-calls historical
   artifacts", "Repeats what the user already said", "Repeats what user
   mentioned in last response" — same concept, 4 phrasings.
3. Unsolicited: "Offers unsolicited options", "Offers unsolicited
   solutions" — same concept, 2 phrasings.
4. Options clarity: "Offers options loaded with jargon", "Paraphrases
   options in a way that adds ambiguity instead of clarity" — same
   symptom (unclear options), different causes, 2 phrasings.

## Decision

Keep the full list as-is. Nothing above was merged or deleted.

## Why not merged now

Intent is to first see whether the current (unmerged, redundant) checklist
fails in practice. If it does, a different approach will be tried instead
of this one. Merging now would remove the ability to compare the two.

## Confirmed non-duplicates (kept distinct on purpose)

- "Offers impractical solutions that don't solve the current problem" —
  a quality failure (solution wanted, but bad), distinct from
  "unsolicited" (not wanted at all).
- "Contains contradictory statements within the same response" — no prior
  item covered internal self-contradiction.
- "Strongly worded statements without receipts" — distinct from
  "over-compensates ... with inflated reasoning": that item is scoped to
  praising the user's own solution; this one covers any unsupported claim.
