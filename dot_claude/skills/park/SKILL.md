---
name: park
description: >-
  Use when user wants to shelve a thought without derailing current work.
  Appends to docs/parked.md as a bullet-point stack.

  **ALWAYS INVOKE THIS SKILL** when user message contains: /park park:
---

# /park

## Mutation Guard

No mutation without the literal word `go` from user. Not "go ahead", not "yes", not "ok" — just `go`, alone.
After every response, full stop — do not auto-continue.

## Steps

1. If `docs/parked.md` doesn't exist, ask user if they want to create it — wait for `go`
2. Extract item from message (content after "park:" or before "/park")
3. Present what will be appended — wait for `go`
4. Append to bottom of `docs/parked.md` — bullet point, timestamped `[YYYY-MM-DD H:MMam/pm]`
5. Reply: "Parked: [item]"
6. Continue current work — do NOT act on parked item