---
name: skill-init
description: Help user create a new Claude Code skill.
disable-model-invocation: true
---


# Reference Skill dirs  
- Personal: `~/.claude/skills/<skill-name>/SKILL.md`
- Project: `.claude/skills/<skill-name>/SKILL.md`


# Skill Creation Workflow

Ask one question at a time. Wait for the user's answer before moving to the next step.
If the user passes arguments with the command, use them to pre-fill answers and skip those steps.

## Step 1 — Name
"What should the skill be named? (This becomes `/your-name`)"

## Step 2 — Scope
"Personal (all projects) or project (this project only)?"

## Step 3 — Description
"Describe what this skill does — Claude uses this to decide when to auto-invoke it."
Help the user refine their description if it's vague.

## Step 4 — Options (one at a time)

Walk through each option below, one per message. For each, explain what it does and show the default. User can say "skip" to keep the default.

1. `disable-model-invocation` (boolean, default: `false`) — `true` means only user can invoke via `/name`, Claude won't auto-trigger.
2. `user-invocable` (boolean, default: `true`) — `false` hides from `/` menu, only Claude can invoke automatically.
3. `allowed-tools` (string, default: none) — Tools Claude can use without permission, e.g. `Read, Grep, Glob`.
4. `model` (string, default: none) — Model override when skill is active.
5. `context` (string, default: none) — Set to `fork` to run in isolated subagent context.
6. `agent` (string, default: none) — Subagent type when `context: fork`. Options: `Explore`, `Plan`, `general-purpose`.
7. `hooks` (object, default: none) — Hooks scoped to this skill's lifecycle.

## Step 5 — Instructions
"What instructions should Claude follow when this skill is invoked?"

## Step 6 — Show Draft
Show the complete SKILL.md draft for review. Ask "Create this, or adjust anything?"

## Step 7 — Create
Create `<scope-dir>/skills/<skill-name>/SKILL.md` with all collected values.
- `name` and `description` are always included in frontmatter (never rely on defaults).
- `description` uses YAML multiline block syntax: `description: |`
- Only include optional fields that the user explicitly set (not defaults/skipped).

## Step 8 — Done
"Created `/name`."
