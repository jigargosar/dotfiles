---
name: tldr
description: Run when the user signals a response was too long, padded, or a
  waste of time — they type "/tldr" or "TMI", or say "too long", "get to the
  point", "tl;dr", "summarize that", "you're rambling". Once invoked, also runs
  on every following turn until the user exits ("verbose", "expand", "drop tldr").
---

# tldr — cut the padding

Invoked because a response (or the default style) ran long, padded, or wasted
the user's time. Recover now, and keep the discipline for the rest of the
conversation.

## Do
1. Lead with the answer. No preamble, no restating the question, no narrating
   what you're about to do.
2. Numbered bullets, one short line each. Prose only when the content needs it.
3. Cite, don't paste. Reference long or abstract resources inline
   (`docs/roadmap.md §2`, `store.ts:107`, `[[slug]]`, a URL) instead of
   reproducing them.
4. Cut anything not load-bearing: caveats, alternatives you won't pursue,
   hedging, filler examples.
5. Cap it. Aim for ≤5 bullets / ≤8 lines unless the user asks for more.

## Don't
1. Don't pad to sound thorough — length is not credibility.
2. Don't re-explain what the user just said or already knows.

## Persistence
Stay in this mode every following turn until the user explicitly exits
("verbose", "expand", "drop tldr").
