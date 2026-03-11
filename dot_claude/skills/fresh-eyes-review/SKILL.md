---
name: fresh-eyes-review
description: Evaluate code through the lens of a first-time reader — not architecture, not correctness, but the reading experience itself. Use when asked to review readability, find noise, or understand what's hard to follow.
argument-hint: "[file-path]"
allowed-tools: Read, Glob, Grep
---

# Readability Review

Evaluate code through the lens of a first-time reader — not architecture, not correctness, but the reading experience itself.

## Trigger

When user asks to review readability, find noise, or understand "what's hard to follow" in a file.

## Method

1. Read the file top-to-bottom in a single pass
2. At each section, note:
   - How many things am I holding in working memory right now?
   - Did I have to scan backward to recall something?
   - Can I tell what this section is for without reading every line?
   - Does this line carry the same visual weight as the important lines around it?
3. Report where you slowed down and why — describe the reading experience, not structural opinions

## What to look for

- Walls of declarations with no signal about purpose or grouping
- Flat functions where every line is a peer — no hierarchy, no chunking
- Setup/plumbing interleaved with core logic
- Variables introduced far from where they're used
- Reader forced to hold too many names before seeing any payoff

## What NOT to do

- Don't jump to architectural critique — coupling, abstraction boundaries, patterns
- Don't propose solutions in the review — first agree on where the noise is
- Don't evaluate correctness or performance
- Don't checklist — the value is in honestly experiencing the read, not pattern-matching
