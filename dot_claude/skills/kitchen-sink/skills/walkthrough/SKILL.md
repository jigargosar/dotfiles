---
name: walkthrough
description: Walk the user through a list one point at a time, stopping after each for their reply. Use when the user says "walkthrough", "/walkthrough", or "walk me through that". The list is the most recent one from an earlier assistant response, or supplied as an argument.
---

# Walkthrough

## Resolve the list

Use the argument if given, else the list in the previous response. Ask if ambiguous.

## Per point — one point per turn

- Header: last point's result in your own words (n / total)
- Describe the point, quoting its content verbatim rather than pointing at it.
- List plausible options, recommend one.
- Wait for the user's reply, respond to it, and stay on the point until told to move. Moving on is the ack.
- Collect info only. Don't act.

## Close

- List all decisions.
