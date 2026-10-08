---
name: board-setup
description: Set up the slice-based workflow board (docs/Board.md) and wire it into CLAUDE.md, importing AGENTS.md when present. Use when the user says board setup or /board-setup.
disable-model-invocation: true
---

Work in the project root.

## 1. `docs/Board.md`

- Missing: create it with the Flow section below.
- Exists without a `# Flow` section: insert the Flow section at the top. Keep everything else.
- Exists with `# Flow` identical to the one below: leave it.
- Exists with `# Flow` that differs: this skill is the canonical copy.
  1. Show the diff between the board's Flow and the one below.
  2. Ask the user, per differing rule: merge into the skill, or drop.
  3. Update the Flow section in this `SKILL.md` (`~/.claude/skills/board-setup/SKILL.md`) with the merged rules.
  4. Replace the board's Flow section with the merged Flow. Keep the rest of the board.

```md
# Flow

- Write slices before any work.
- Never write another slice until a slice is complete
- Either delete the todo item, or move it to new slice.
- If a slice is long reorder it. And either finish it, or move to next slice once a part is done.
- Work done by mistake, without following these rules: add it to the current slice, marked done.
```

## 2. `CLAUDE.md`

- Missing: create it.
- If `AGENTS.md` exists and `CLAUDE.md` has no `@AGENTS.md` line, add `@AGENTS.md` as the first line.
- If `CLAUDE.md` has no reference to `docs/Board.md`, add `Follow the Flow in \`docs/Board.md\`.` after the imports.
- Never remove or reword existing content.

## 3. Report

List each file as created, updated, or unchanged. Do not commit.
