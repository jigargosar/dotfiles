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

- Write a task in the current slice (chunk) before you work on it.
- A slice is one flat list of the work to do.
- Reordering is always allowed.
- When a task is done and tested, tick it, move it to just below the last done item, and commit.
- A related task found during the work joins the current slice.
- Work done without a task: add it to the current slice, ticked.
- A new slice starts when a different context comes up, or when the current slice gets too long; its open items move to the new slice. A long slice hides its open tasks, so when a part is done and tested, suggest a new slice.
- Closed slices need not follow the Workflow. Do not read a closed slice as an example of the rules.
```

## 2. `CLAUDE.md`

- Missing: create it.
- If `AGENTS.md` exists and `CLAUDE.md` has no `@AGENTS.md` line, add `@AGENTS.md` as the first line.
- If `CLAUDE.md` has no reference to `docs/Board.md`, add `Follow the Workflow in \`docs/Board.md\`.` after the imports. If it says "Follow the Flow", change it to "Follow the Workflow".
- Never remove or reword existing content.

## 3. Report

List each file as created, updated, or unchanged. Do not commit.
