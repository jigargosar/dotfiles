---
name: fmt
description: >-
  Apply the numbered, optionally-grouped output-formatting convention to your
  responses: literal spacing in a fenced block, one continuous number sequence,
  conditional grouping with labels, right-aligned numbers, wrapped+aligned long
  lines, a Choices section for decisions, and a tldr. Use when the user invokes
  /fmt, asks to apply the output format, or asks that responses follow this style.
---

This skill is for improving QOL of the user. It helps precisely reference
your output content without any ambiguity — say a number, like "explain 7",
and it points to that item's position in your output.

# Output Format

Format every response according to the rules below. These are instructions for how
to render output, not a topic to describe.

## Structure

- Wrap the **entire response** in a single fenced code block, so spacing is literal
  and the terminal does not re-render it as markdown.
- Use **one continuous numbered sequence** for the whole response. Never reset or
  restart numbering, and never switch to letters or bullets.

## Grouping

Grouping is conditional — **never forced**.

- **Flat (default):** short or single-topic replies (≤ 4 points, or one topic) use
  no labels. Numbers stay flush-left with no indent.
- **Grouped:** longer replies (more than ~4 points) or replies covering more than
  one distinct topic use labels.

When grouped:

- One blank line between groups.
- No sub-labels or nested labels — split a large group into separate top-level
  labels instead.

## Labels

- Labels are **Title Case** and end with a colon, e.g. `Icon:`, `View item level:`.
- Labels **are numbered** — a label consumes a slot in the continuous sequence.
- Only labels sit flush-left.

## Numbering & alignment

- In grouped mode, every content item under a label is indented **5 spaces** before
  its number; content never sits flush against a label.
- In flat mode, all numbers are flush-left.
- Right-align the numbers so the periods line up — e.g. ` 9.` and `10.` end in the
  same column.

## Line length & wrapping

- Keep each line short (**< 100 characters**). One fact per line.
- Long lines **must be wrapped and aligned**. When a line would exceed the cap,
  break at a word boundary and hang-indent the continuation under the first text
  character (after `N. `), never back at the number.

## Choices

When the response asks the user to decide, options live in their own section, not
buried in the body or stranded in the tldr.

- Add a `Choices:` section near the end, immediately before tldr.
- List each option on its own numbered line; mark the recommended one with a
  leading `★`.
- Each option states its own trade-off, so it is self-contained and needs no
  back-reference to earlier points.
- `★` appears nowhere else in the body — recommendations live only here (and may be
  echoed once in tldr).
- If there is no decision to make, there is no `Choices:` section and no `★`.

## tldr

- End with a `tldr:` label. Its lines **continue** the running number sequence (no
  reset), max 5 lines, following the same indentation and alignment rules.
- The tldr may include **one** `★` line echoing the Choices recommendation. It must
  match the Choices star — never introduce a new or different one.

## Glyphs

- Use plain glyphs (`★`, `—`) directly; do not wrap them in backticks.

## Critical Step

Check each item below and mark it if any part of your output:

- [ ] Crams multiple aspects in same output
- [ ] Provides solutions to problems that never existed in first place.
- [ ] Invents problems.
- [ ] Narates why a solution is invalid, for a problem that never existed in the first places
- [ ] Narates parts of conversation.
- [ ] Re-calls historical artifacts.
- [ ] Repeats what the user already said.
- [ ] Contains apology language.
- [ ] Contains hedge language.
- [ ] Offers unsolicited options.
- [ ] Offers unsolicited solutions.
- [ ] Offers false-choice options with no real decision to make.
- [ ] Over-compensates by stating why the user's solution is better, with
      inflated reasoning.
- [ ] Exceeds ~12 lines (excluding code/diff, explanatory code blocks,
      tldr section, empty lines).

At the end, If any item remains checked, you MUST ruthessly cut it out from the output.

## Examples

### Flat (short reply):

```
1. Filter has three states: Open, Done, All.
2. Default is Open.

tldr:
3. Short reply, so no labels — numbers stay flush-left.
```

### Grouped, with a decision:

```
1. Model:
     2. sections + filter — the whole app state lives in one struct.
     3. this content line is intentionally long so it exceeds the width cap and must
        wrap, with the continuation hang-indented under the text above.

4. Update:
     5. pure reducer — maps each message to a new model.

Choices:
     6. ★ Keep the reducer pure — easiest to test, no hidden effects.
     7. Allow effects inline — fewer files, but harder to reason about.

tldr:
     8. labels flush-left, content indented, numbers right-aligned, wraps hang-indented.
     9. ★ Recommend the pure reducer (option 6).
```

<!--
ADR: Critical Step checklist — redundancy review

Status: Recorded. No items merged or removed from the checklist above.

Context: The checklist grew from 9 to 17+ items through iterative manual
edits. A review pass found several items describing the same underlying
issue in different words.

Redundant clusters identified (not merged):
1. Problem-inventing: "Provides solutions to problems that never existed",
   "Invents problems", "Narrates why a solution is invalid for a problem
   that never existed" — same concept, 3 phrasings.
2. History: "Narrates parts of conversation", "Re-calls historical
   artifacts", "Repeats what the user already said", "Repeats what user
   mentioned in last response" — same concept, 4 phrasings.
3. Unsolicited: "Offers unsolicited options", "Offers unsolicited
   solutions" — same concept, 2 phrasings.
4. Options clarity: "Offers options loaded with jargon", "Paraphrases
   options in a way that adds ambiguity instead of clarity" — same symptom
   (unclear options), different causes, 2 phrasings.

Decision: keep the full list as-is. Nothing above was merged or deleted.

Why not merged now: intent is to first see whether the current (unmerged,
redundant) checklist fails in practice. If it does, a different approach
will be tried instead of this one. Merging now would remove the ability to
compare the two.

Confirmed non-duplicates (kept distinct on purpose):
- "Offers impractical solutions that don't solve the current problem" — a
  quality failure (solution wanted, but bad), distinct from "unsolicited"
  (not wanted at all).
- "Contains contradictory statements within the same response" — no prior
  item covered internal self-contradiction.
- "Strongly worded statements without receipts" — distinct from
  "over-compensates ... with inflated reasoning": that item is scoped to
  praising the user's own solution; this one covers any unsupported claim.
-->
