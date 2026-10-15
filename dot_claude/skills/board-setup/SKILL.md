---
name: board-setup
description: Set up the slice-based workflow board (docs/Board.md) and wire it into CLAUDE.md, importing AGENTS.md when present. Use when the user says board setup or /board-setup.
disable-model-invocation: true
---

Work in the project root.

## 1. `docs/Board.md`

- Missing: create it with the Workflow section below.
- Exists without a `# Workflow` section (an old `# Flow` counts as missing): insert the Workflow section at the top, in place of any `# Flow`. Keep everything else.
- Exists with `# Workflow` identical to the one below: leave it.
- Exists with `# Workflow` that differs: this skill is the canonical copy.
  1. Show the diff between the board's Workflow and the one below.
  2. Ask the user, per differing rule: merge into the skill, or drop.
  3. Update the Workflow section in this `SKILL.md` (`~/.claude/skills/board-setup/SKILL.md`) with the merged rules.
  4. Replace the board's Workflow section with the merged Workflow. Keep the rest of the board.

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

## 2. `CLAUDE.md`

- Missing: create it.
- If `AGENTS.md` exists and `CLAUDE.md` has no `@AGENTS.md` line, add `@AGENTS.md` as the first line.
- If `CLAUDE.md` has no reference to `docs/Board.md`, add `Follow the Workflow in \`docs/Board.md\`.` after the imports. If it says "Follow the Flow", change it to "Follow the Workflow".
- Never remove or reword existing content.

## 3. Report

List each file as created, updated, or unchanged. Do not commit.
