---
name: board-setup
description: > 
    Purposefully constrained alternative workflow of Kanban, todo, issues etc. 
    It removes the ceremony of icebox/backlog, by putting cart before the horse. 
disable-model-invocation: true
---

Work in the project root.

## Board

Compare the Workflow in the project's `docs/Board.md` with the Workflow below.

- Absent: add the Workflow below at the top of `docs/Board.md`. Create the file if needed.
- Same: nothing to do.
- Different: discuss the differences with the user. Either side may have something the other lacks or does better. Agree on one Workflow, then write it both here and in the board.

```md
# Workflow

Every plan's first step is recording it on the board. No task is ever started before it is recorded on the board.

The board holds all known work in one list, so the next task is never a guess.

## Terms

- Slice: a `# Slice <n>` heading and its tasks.
- Task: one item of work, written `- [ ] text`.
- Nested task: a task under another task, one level deep. A task is done when all its nested tasks are.
- Marks: `[ ]` open, not built yet. `[t]` built, test pending. `[x]` done: built and tested.

## Slices

- The last slice is open. New tasks go into it.
- Start a new slice when the context changes, or when the open slice gets too long, since a long slice hides its open tasks. Suggest one once a part of the open slice is done.
- Starting a new slice moves every open task into it and closes the old slice.
- The last closed slice stays on the board, above the open slice, so it shows what was just done and what moved on. Older closed slices move to `docs/Board-archive-<date>.md`, one file per slice.
- Closed slices are frozen. They may predate these rules, so do not read one as an example.

## Tasks

- In the open slice, any task may be written, reworded, moved (also into or out of another task) or deleted at any time.
- Claude formats a line that is not yet a task.
- When a task is done: mark it `[x]`, move it below the last done task, and commit. Done tasks then sit above open ones, so progress reads top to bottom.
- Delete a task that is no longer wanted. `[x]` means done, never dropped.

## Commits

- Commit when a task is done, and whenever uncommitted work grows, even mid-task (message prefix "WIP:"). Small commits are cheap to review and undo.

---
```

## CLAUDE.md

Write the following line in `CLAUDE.md` if it is missing. Don't report it either way.

Every plan's first step MUST be recording it in `docs/Board.md`. No task may ever start before it is recorded there. Follow the Workflow there.

## Report

Say what changed in `docs/Board.md`. Do not commit.

Once setup is done, suggest changes to the Workflow if you see any.
