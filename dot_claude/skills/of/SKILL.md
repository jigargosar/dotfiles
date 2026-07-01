---
name: of
description: >-
  Apply the numbered, optionally-grouped output-formatting convention to your
  responses: literal spacing in a fenced block, one continuous number sequence,
  conditional grouping with labels, right-aligned numbers, wrapped+aligned long
  lines, a Choices section for decisions, and a tldr. Use when the user invokes
  /of, asks to apply the output format, or asks that responses follow this style.
---

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

Check each item below and mark it if any part of your output matches

- [ ] Contains narration
- [ ] Recaps history.
- [ ] Repeats what the user already said.
- [ ] Contains apology language.
- [ ] Contains hedge language.
- [ ] unneeded and unsolicited options.
- [ ] Offers false-choice options with no real decision to make.
- [ ] Explains why user's solution is better, and why it is applicable.
- [ ] Body exceeds ~12 lines (excluding code/diff, explanatory code blocks, tldr section, empty lines)

If any item remains checked, you MUST remove it from the output. And continue Critical Step process

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
