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

The board exists so that all known work is written in one list, and the next task is never a guess.

- The last slice is the open slice. All other slices are closed.
- The open slice is one list of tasks: all known work, ticked or not. A task may have a sub-list of its steps, one level, each step ticked on its own.
- Any task may be written at any time. Work on a task only after it is written.
- Reorder tasks when it helps.
- When a task is done and tested: tick it, move it below the last ticked task, commit.
- Work done without a task: add it to the open slice, ticked.
- A task that is no longer wanted is deleted.
- Start a new slice when the context changes, or when the open slice is too long. Move every unticked task into it. The old slice is then closed.
- When a part of a long slice is done and tested, suggest a new slice.
- Closed slices need not follow the Workflow. Do not read a closed slice as an example of the rules.
```

## CLAUDE.md

`CLAUDE.md` imports `@AGENTS.md` when that file exists, and says to follow the Workflow in `docs/Board.md`. Add what is missing. Never remove or reword what is there.

## Report

Say what changed in each file. Do not commit.

Once setup is done, suggest changes to the Workflow if you see any.