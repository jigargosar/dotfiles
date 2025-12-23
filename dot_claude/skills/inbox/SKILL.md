---
name: inbox
description: Manage roadmap workflow - process inbox items or add new tasks. Use when user says "process inbox", "add to roadmap", or uses "inbox:" prefix.
---

# Inbox

Manage roadmap workflow - process inbox items or add new tasks.

## Triggers

- `/inbox` or `/inbox <task>` - user command
- `inbox: <task>` - quick add syntax
- "process inbox", "add to roadmap" - context triggers

## Instructions

### Quick Add (with argument)

When invoked with a task description (e.g., `/inbox fix login bug` or `inbox: fix login bug`):
- Add task to InBox section in ROADMAP.md
- No discussion needed, just add it

### Process Inbox (no argument)

When invoked without argument or asked to "process inbox":

1. Read ROADMAP.md
2. Present each InBox item ONE AT A TIME with options and recommendation:

```
**[Item name]**

1. Ready
2. In Progress
3. Done: Pending Review
4. Done
5. Backlog
```

Add suggestions as option 6+ when applicable (e.g., merge with related item, split into subtasks, rename for clarity).

3. Wait for user selection before proceeding to next item
4. Apply changes after each selection

### Create ROADMAP.md (if missing)

If ROADMAP.md doesn't exist, copy from `templates/ROADMAP.md`.

## Workflow Rules

- Task flow: Ready → In Progress → Done: Pending Review (await approval) → Done
- InBox is the entry point for all new items
- Never move items without explicit user approval
- Keep task descriptions concise but complete

Be concise but friendly. Avoid unnecessary verbosity.