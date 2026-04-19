---
name: skill-init
description: Create a new skill or command.
when_to_use: |
  Trigger when the user wants to create a skill or command (implicit or explicit), wants to
  automate a workflow, or is repeating the same set of instructions over and over in the
  current session.
argument-hint: [what the skill/command should do]
disable-model-invocation: false
user-invocable: true
---

Treat users request for command creation same as skill creation. Commands are deprecated in favour of skills.

Draft the full SKILL.md, write it to disk as the first-draft artifact, offer to open it, then iterate on the frontmatter as a numbered list the user can reference by number. Don't run a one-question-at-a-time questionnaire — it's slow and most fields have good inferred defaults.

## Where skills go

1. Personal (all projects): `~/.claude/skills/<name>/SKILL.md`
2. Project-local (this repo only): `.claude/skills/<name>/SKILL.md`

## Flow

### Step 1 — Infer intent (loop until enough signal)

Use any args passed with `/skill-init` and the recent conversation to decide what workflow or pattern the skill should capture. Enough signal = a clear-enough purpose statement plus a plausible name.

If signal is thin, ask lightly: "What should the skill do?" Reassure the user that this is a draft — easy to rename, edit, or toss — so the stakes stay low. If the user hesitates or says they don't know yet, loop: reassure again and take whatever they give, even a one-liner. Exit the loop once intent coheres. If after a few gentle prompts no intent coheres, surface the gap: state what couldn't be inferred, then stop. Don't force a draft before it's ready, and don't interrogate.

If the user's intent contains explicit style directives (e.g., "no padding", "short responses", "no long explanations"), capture them and apply to (a) the generated skill's body as standing instructions, and (b) this skill-authoring session's own response style from that point onward.

### Step 2 — Draft

Produce the complete SKILL.md in memory: frontmatter with all 7 core fields populated (values inferred from intent) plus the body. The 7 core fields are always written explicitly.

### Step 2.5 — Pick scope

Use AskUserQuestion: "Where should this skill live?" Options: `★ Personal (Recommended)` and `Project`, ordered with the inferred-best first based on intent (project-specific workflow → Project; general workflow → Personal). This replaces silent default inference.

### Step 3 — Write the first draft to disk

Before calling `Write`, scan every populated frontmatter field and verify: (a) no mid-sentence truncation, (b) values match their declared types (`allowed-tools` is a proper string/list, booleans are bare words), (c) multi-line values use YAML block syntax correctly.

Before calling `Write`, scan the body for inline shell commands and tool invocations (`Bash(...)`, `Read`, `Write`, `AskUserQuestion`, etc.). Cross-check against `allowed-tools`. Add missing entries.

Use the `Write` tool to create the file at the chosen scope's path (see "Where skills go"). This is the first-draft artifact — the user inspects the real file in their editor during the review loop.

### Step 4 — Offer to open the file

Use AskUserQuestion:

- **Question:** "Open the file in your editor for review?"
- **Options:** Mark the inferred-best option first with `★ ... (Recommended)`. Infer from context: for a long body that deserves visual review, `★ Yes (Recommended)` / `No`; for a trivial draft, `★ No (Recommended)` / `Yes`.

If `Yes`, open the file in the system's default handler — invoke the `open` skill if available, otherwise run `start <path>` (Windows), `open <path>` (macOS), or `xdg-open <path>` (Linux).

### Step 5 — Show frontmatter as a numbered 1–7 list

In chat, render the frontmatter fields as a numbered list where each line has: field name, current value, one-line description, and a recommendation.

Lead with the resolved path (e.g., `Writing to ~/.claude/skills/<name>/SKILL.md`) above the list so the user sees the consequence of the `name` choice while reviewing.

Example shape (Claude fills in real values):

1. `name: <slug>` — slug used for `/<slug>` invocation; falls back to directory name if omitted. Recommend: kebab-case derived from the intent.
2. `description: <text>` — primary triggering text Claude reads to decide when to invoke. Recommend: short purpose statement, not trigger phrases.
3. `when_to_use: <text>` — extra trigger phrases/examples; appended to `description` in the skill listing (combined 1,536-char cap). Recommend: list likely user phrasings in the user's own voice.
4. `argument-hint: [x]` — autocomplete hint shown when user types `/name `. Conventions: `<required>`, `[optional]`, `|` = pick one, `...` = variadic. Recommend: set when the skill should accept arguments passed with `/name <args>` (e.g., `<filename>`, `[json|yaml|toml] <file>`); otherwise `none`.
5. `disable-model-invocation: false` — Claude can auto-invoke when relevant. Recommend: flip to `true` for side-effect actions like commit/deploy/send where timing must be controlled.
6. `user-invocable: true` — shows in the `/` menu. Recommend: flip to `false` for background-knowledge-only skills not meant for manual invocation.
7. `allowed-tools: <list or none>` — tools the skill pre-approves so Claude doesn't ask per use. Recommend: pre-approve tools the skill will invoke on every run (e.g., `Write` for a generator, `Bash(git *)` for a commit skill).

### Step 6 — Free-text reply loop for core fields

Accept flexible replies:

- `approve` / `yes` / `ok` / `lgtm` — advance to Step 7.
- `cancel` / `no` — delete the file from disk and abort.
- Reference by number to change: `3: <new when_to_use>`, `change 5 to true`, `make 6 false`, etc. Rewrite the file on each change. If the change updates `name`, delete the old file and write to the new path.
- Anything else — treat as general edit instructions (could affect body or multiple fields); rewrite the whole SKILL.md on disk, re-show the list, re-enter the loop.

After any rewrite (numbered change OR free-text edit), **always redisplay the updated 1–7 numbered list in chat** — not just a silent `Read`. Every iteration must end with the list visible so the user can reference items by number.

Loop until `approve`.

### Step 7 — Ask about advanced options

Before the AUQ, scan the original user intent for explicit mentions of advanced fields (`model`, `effort`, `shell`, `context`, `agent`, `paths`, `hooks`). If any are mentioned, pre-fill them in the upcoming Step 8 list and note so in the AUQ description ("you mentioned X — I've pre-filled it below").

Use AskUserQuestion:

- **Question:** "See advanced options? (model, effort, shell, context, agent, paths, hooks)"
- **Options:** `★ No (Recommended)` / `Yes`

If `No` → done; the file on disk is the final version.
If `Yes` → Step 8 (advanced list).

### Step 8 — Advanced fields list (only if user opted in)

The user opted in, so they're interested — provide real recommendations, don't skimp. Render advanced fields 8–14 as a numbered list using the same format as Step 5 (field + value + description + recommendation). All start at `[not set]`.

8. `model: [not set]` — override the model while the skill is active (e.g., `claude-opus-4-7`, `claude-sonnet-4-6`, `claude-haiku-4-5`). Recommend: leave unset unless the task needs a specific model tier.
9. `effort: [not set]` — effort level (`low`/`medium`/`high`/`xhigh`/`max`) overriding the session. Recommend: leave unset; most skills inherit fine.
10. `shell: [not set]` — shell used when the skill injects shell commands inline (`bash` default, or `powershell`). Recommend: leave unset unless the skill will inject inline shell commands and needs PowerShell on Windows.
11. `context: [not set]` — set to `fork` to run in a forked subagent with isolated context. Recommend: use for research/exploration/audit skills where isolation protects the main conversation.
12. `agent: [not set]` — subagent type when `context: fork` (`Explore`, `Plan`, `general-purpose`, or a custom agent from `.claude/agents/`). Recommend: set only if `context: fork` is set; match the type to the task (Explore for read-only codebase nav, Plan for architecture, general-purpose otherwise).
13. `paths: [not set]` — glob patterns that gate auto-activation. Recommend: use for file-type-scoped skills (e.g., `**/*.test.ts` for a test-writing skill); skip otherwise.
14. `hooks: [not set]` — lifecycle hooks scoped to this skill. Recommend: advanced; leave unset unless there's a specific lifecycle automation need.

Same reply pattern as Step 6: reference by number to set a value (rewrite file each change); `approve` to finish; `cancel` to delete the file and abort. Only advanced fields the user explicitly set are written to the file; unset ones are omitted.

## Writing the description

The description is the primary triggering mechanism — Claude reads it to decide whether to invoke the skill. Put the *purpose* in `description`; put *trigger phrases* in `when_to_use`. They're combined in the skill listing and jointly capped at 1,536 characters.

Be slightly pushy about triggers in `when_to_use` so the skill doesn't undertrigger. Use natural phrasings the user would actually type, not abstractions.

Example:

- Thin: `description: Helps with git commits.`
- Good: `description: Create conventional-format git commits from staged changes.` + `when_to_use: Trigger when the user says "commit", "make a commit", or has staged changes and asks what to do next.`

## Writing the body

Keep it tight. State what the skill does, the sequence of steps, and any constraints the user mentioned. Prefer imperative form ("Read X, then write Y") over hedging. Don't pad with boilerplate.

When drafting recommendations in the generated skill (both for the 7 core fields and for any guidance the skill offers future users), use **design-intent language** — describe the skill's intended behavior, not observations of the not-yet-existing skill's properties. Prefer "set when the skill should X" or "set if the skill should X" over "set if skill does X". Prefer modal verbs (will, should, needs to) over present-tense (takes, uses, needs). Avoid second-person "you want" — the referent is ambiguous in static SKILL.md text.

If the generated skill's flow involves inference (from user intent, args, or context), include a graceful exit for when no signal can be gathered: surface the gap, state what couldn't be inferred, then stop. Don't force output.

## Editing after the draft

Any reply that isn't `approve`/`cancel`/a numbered change is treated as general edit instructions. Rewrite the whole SKILL.md on disk incorporating the feedback, show the updated list again, re-enter the reply loop. Accept plain language — never ask the user to enumerate field names or use structured syntax.
