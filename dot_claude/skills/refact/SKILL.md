---
name: refact
description: >-
  Practical, language-agnostic fundamentals for improving code readability
  and maintainability — favors concrete, actionable guidance over
  theoretical jargon.
when_to_use: >-
  When refactoring, reviewing code for readability, or advising on
  maintainability.
user-invocable: true
disable-model-invocation: true
---

# Refactoring Fundamentals

Practical, language-agnostic principles for readability and maintainability.
No theoretical jargon — apply directly to the code at hand, not in the abstract.

## Near-universal (low dispute)

1. Name for truth, not history — a name should say what a thing is now, not how
   it got built or what it used to be called.
2. Small enough to hold in your head — if you can't summarize a function/file in
   one sentence, it's doing too much; split it.
3. Delete before you add — dead code, unused exports, and stale comments
   actively mislead the next reader.
4. Comments explain why, never what — the code already says what; a comment
   only earns its place by capturing a reason invisible in the code.

## Heuristic (useful, but contested — apply with judgment)

5. Duplicate twice, abstract on the third — premature abstraction is often
   worse than duplication; wait until the right shape is visible.
6. Make wrong states hard to write — fewer boolean flags/optional fields that
   can combine into nonsense; prefer shapes where invalid combinations can't
   be expressed.
7. Obvious beats clever — if you have to admire your own cleverness, a future
   reader will pay for it.
8. Same problem, same solution, everywhere — consistency across the codebase
   beats local elegance.

## How to apply

- Default to the "near-universal" section without caveats.
- Treat the "heuristic" section as levers, not laws — surface the tension
  (e.g. DRY vs. avoid-premature-abstraction) rather than picking a side
  unprompted.
- Ground every suggestion in the actual file/function under discussion —
  never propose a fix for a problem that isn't present.
