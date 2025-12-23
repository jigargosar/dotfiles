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
2. Present each InBox item ONE AT A TIME with options:

```
**1. [Item name]**

1. Ready
2. In Progress
3. Done: Pending Review
4. Done
5. Backlog (Recommended - [brief reason])
```

If related items exist, add: `6. Merge with "[related item]" in [section]`

3. Wait for user selection before proceeding to next item
4. Apply changes after each selection

### Create ROADMAP.md (if missing)

If ROADMAP.md doesn't exist, create with structure:

```markdown
# Roadmap

## InBox (each item to be evaluated for placement)

## Ready

## In Progress

## Done: Pending Review

## Done (commit when moved here)

## Backlog
```

## Workflow Rules

- Task flow: Ready → In Progress → Done: Pending Review (await approval) → Done
- InBox is the entry point for all new items
- Never move items without explicit user approval
- Keep task descriptions concise but complete

Be terse. No verbose explanations.