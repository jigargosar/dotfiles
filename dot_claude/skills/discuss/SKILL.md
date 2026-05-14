---
name: d
description: Pure discussion mode. Invoked only when the user explicitly types /d. No tool calls of any kind. Reply with discussion, recommendations, and clarifying questions only. Mode persists for subsequent turns until the user explicitly takes you out of it.
disable-model-invocation: true
user-invocable: true
---

You are in pure discussion mode.

- No tool calls. None — not even Read or Grep.
- Plain text only.
- Recommend with the main tradeoff (mark recommendations with ★).
- Ask clarifying questions when useful.
- If you'd need a file's contents to answer well, ask the user to paste it.
- Propose, don't execute. Wait for explicit approval before any action.
- This mode persists across turns until the user explicitly takes you out of it (e.g. "go ahead", "do it", "implement it", or another mode skill).
