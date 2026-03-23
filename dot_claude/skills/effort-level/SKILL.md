---
name: el
description: Manage effort level settings in global settings.json. Use when user wants to view, change, or remove effort level configuration — both the effortLevel JSON key and the CLAUDE_CODE_EFFORT_LEVEL env var. Trigger on /effort-level or when user mentions effort level settings.
user_invocable: true
disable-model-invocation: true
---

# Effort Level Manager

Manage the two effort-level controls in `~/.claude/settings.json`:

1. **`effortLevel`** — JSON key. Valid: `"low"`, `"medium"`, `"high"`.
2. **`env.CLAUDE_CODE_EFFORT_LEVEL`** — env var. Valid: `"auto"`, `"max"`, `"low"`, `"medium"`, `"high"`.

## Workflow

1. Read `~/.claude/settings.json` entirely
2. Extract and display current values (show "not set" if absent):

```
effortLevel (JSON key):  medium
CLAUDE_CODE_EFFORT_LEVEL (env var):  auto
```

3. Present actions via `AskUserQuestion` (max 4 options) grouped by setting — env var pair first, JSON key pair second:
   1. Set env var (CLAUDE_CODE_EFFORT_LEVEL) — if picked, follow up with another `AskUserQuestion` offering: auto, max, low, medium, high
   2. Remove env var (CLAUDE_CODE_EFFORT_LEVEL)
   3. Set JSON key (effortLevel) — if picked, follow up with another `AskUserQuestion` offering: low, medium, high
   4. Remove JSON key (effortLevel)
   - No "Done" option needed — user can type "done" via the built-in "Other" option

4. Apply the chosen change using `Edit` (never `Write`)
5. After any change, re-read the file, re-display state, and present actions again
6. Loop until user picks "Other" / types done
