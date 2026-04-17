---
name: skill-init
description: Help user create a new Claude Code skill.
disable-model-invocation: false
---


# Reference Skill dirs
- Personal: `~/.claude/skills/<skill-name>/SKILL.md`
- Project: `.claude/skills/<skill-name>/SKILL.md`


# Skill Creation Workflow

Ask **one question at a time**. Wait for the user's answer before moving to the next step.
If the user passes arguments with the command, use them to pre-fill answers and skip those steps.

## Pre-flight — Scan Context for Suggestions

Before asking Step 1, silently review the recent conversation and draft plausible defaults for:
- **Name** — a short kebab-case slug derived from what the user has been working on or asking for (e.g. recurring verb/noun, the tool they keep reaching for).
- **Description** — one sentence drawn from the pain point or repeated task they've described.
- **Scope** — `personal` if the need sounds cross-project / habitual; `project` if it's tied to this repo's stack, files, or conventions.
- **Instructions** — a draft body assembled from any workflow, checklist, or steps they've walked through in conversation.
- **allowed-tools** — tools actually used in the recent turns (Read, Grep, Bash, WebFetch, specific MCP tools, etc.).

When you have a plausible suggestion, present it inline as a default the user can accept:
`Name? [suggested: \`open-pr\`]`
The user can reply `yes` / `ok` to accept, type a replacement, or edit. If you have no confident suggestion, ask the plain question without a default. Never fabricate suggestions that aren't grounded in the conversation.

### No-args harvester mode

If `/skill-init` is invoked with **no arguments**, first scan the last ~30 conversation turns for repeated manual patterns the user might want to reify as a skill — recurring command sequences, repeated "can you also..." follow-ups, phrases like "every time I" or "same thing again," manually invoked workflows the user has walked you through twice or more.

Present 2–3 ranked candidate skills via AskUserQuestion. Each option should show the inferred name + one-line description. The user picks one, and its details pre-fill Step 1 (name) and Step 3 (description). If no plausible candidates exist, say so and fall through to the normal Step 1 prompt.

Only surface candidates grounded in actual repeated behavior — one-off sequences that looked repetitive don't count.

## Question Style — When to Use AskUserQuestion vs Free Text

Use **AskUserQuestion** for short-choice questions:
- Scope (`personal` / `project`)
- Booleans (`disable-model-invocation`, `user-invocable`) — options: `true` / `false` / `skip (keep default)`
- Enums (`context`: `none` / `fork`; `agent`: `Explore` / `Plan` / `general-purpose` / `skip`)
- Final confirmation (`Create` / `Adjust` / `Cancel`)

Use **free-text prompts** for open-ended input:
- Name
- Description
- `allowed-tools` string (comma-separated)
- `model` string
- Multi-line instructions body

Suggestions (from the Pre-flight scan) apply to both styles: surface them as the pre-selected option in AskUserQuestion, or as an inline `[suggested: ...]` default in free-text prompts.

## Step 1 — Name (free text)
"What should the skill be named? (Becomes `/your-name`)"
If you have a suggestion: `Name? [suggested: \`<slug>\`]`

## Step 2 — Scope (AskUserQuestion)
Question: "Where should this skill live?"
Options:
- `personal` — available in all projects (`~/.claude/skills/`)
- `project` — only this project (`.claude/skills/`)
Pre-select the suggested scope if one was inferred.

## Step 3 — Description (free text)
"Describe what this skill does — Claude uses this to decide when to auto-invoke it."
If you drafted one: `Description? [suggested: "<draft>"]`

## Step 4 — Options (one at a time)

Walk through each option below in order, one per message. Explain briefly what it does. User can always say "skip" to omit the field (it won't be written to frontmatter).

1. **`disable-model-invocation`** — AskUserQuestion
   "Disable automatic model invocation? (`true` = only user can invoke via `/name`)"
   Options: `false (default)` / `true` / `skip`

2. **`user-invocable`** — AskUserQuestion
   "Show in the `/` menu for manual invocation?"
   Options: `true (default)` / `false` / `skip`

3. **`allowed-tools`** — free text
   "Tools Claude can use without asking permission? (comma-separated, e.g. `Read, Grep, Glob`. Type `skip` to omit.)"
   If suggestions exist from the scan: `[suggested: \`Read, Grep, Bash\`]`

4. **`model`** — free text
   "Model override while this skill is active? (e.g. `claude-sonnet-4-5`. Type `skip` to omit.)"

5. **`context`** — AskUserQuestion
   "Run in the main context or fork into an isolated subagent?"
   Options: `skip (main context)` / `fork`

6. **`agent`** — AskUserQuestion (only ask if `context: fork`)
   "Which subagent type?"
   Options: `Explore` / `Plan` / `general-purpose` / `skip`

7. **`hooks`** — free text
   "Any hooks scoped to this skill's lifecycle? (paste YAML, or `skip`.)"

## Step 5 — Instructions (free text, multi-line)
"What instructions should Claude follow when this skill is invoked?"
If a draft was assembled from the conversation:
```
Instructions? [suggested draft below — reply `yes` to accept, or paste your own]
---
<draft body>
---
```

## Step 6 — Show Draft
Render the complete SKILL.md (frontmatter + body) for review.

Then **AskUserQuestion**: "Ready to create?"
Options:
- `Create` — write the file
- `Adjust` — name the field(s) to change, loop back
- `Cancel` — abort, write nothing

## Step 7 — Create
Write `<scope-dir>/skills/<skill-name>/SKILL.md` using the collected values.

Frontmatter rules (enforce strictly):
- `name` and `description` are **always** present — never omit, never rely on defaults.
- `description` uses YAML multi-line block syntax:
  ```yaml
  description: |
    <description text, may span lines>
  ```
- Only include optional fields the user **explicitly set**. Skipped fields and unchanged defaults must not appear in frontmatter.
- Field order in frontmatter: `name`, `description`, then any optional fields in the order asked.

## Step 8 — Done
"Created `/name` at `<absolute-path>`."
