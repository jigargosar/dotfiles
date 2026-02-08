---
name: unpark
description: >-
  Use when user wants to resume a parked item.
  Reads docs/parked.md and presents items for selection.

  **ALWAYS INVOKE THIS SKILL** when user message contains: /unpark
---

# /unpark

## Mutation Guard

No mutation without the literal word `go` from user. Not "go ahead", not "yes", not "ok" — just `go`, alone.
After every response, full stop — do not auto-continue.

## Steps

1. If `docs/parked.md` doesn't exist, ask user if they want to create it — wait for `go`
2. Read `docs/parked.md`, present items as numbered list with relative timestamps
   - "just now", "5 min ago", "2 hours ago", "yesterday", "3 days ago", etc.
3. User selects number
4. Work on selected item
5. On completion: single commit containing both the work and removal of item from parked.md — wait for `go` before committing