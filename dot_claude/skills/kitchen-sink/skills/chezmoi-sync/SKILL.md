---
name: chezmoi-sync
description: Sync chezmoi-managed target files back to source and push to remote. Use when user mentions chezmoi, pushing dotfiles, or after editing files like ~/.claude/CLAUDE.md
disable-model-invocation: true
user-invocable: true
model: inherit
---

# Rules

- Run in Bash, not PowerShell. Run commands exactly as written (don't split `&&` chains) and show each output verbatim before the next.
- Never run `chezmoi apply` — it overwrites target files with source state, causing data loss.
- STOP means: stop and ask the user how to proceed. Never continue automatically.

# Commands

Status check:

```bash
chezmoi status && echo "==GIT==" && chezmoi git -- status -sb
```

Empty chezmoi section and no file lines in git section means clean.

Commit & push:

```bash
chezmoi git -- add <source-files...> && chezmoi git -- commit -m "<concise message from context>" && chezmoi git -- push --follow-tags
```

- List source files explicitly by chezmoi name (e.g. `dot_claude/CLAUDE.md` for `~/.claude/CLAUDE.md`); never `-A` or `.`.
- `chezmoi git` needs `--` before git options, otherwise chezmoi parses them and errors.

# Workflow

1. Run Status check and STOP if:
   1. git section has file lines, or branch line shows `[ahead N]` / `[behind N]`
   2. chezmoi section lists more than 20 files
2. Run `chezmoi diff > /dev/null 2>&1` with `run_in_background: true` and STOP if:
   1. exit code is not 0 (wait for the completion notification; don't re-run or poll)
3. For every file in chezmoi section (not just ones related to the current task):
   1. Use absolute or `~`-prefixed paths; shell cwd may not be `$HOME`.
   2. Quote only the segment with spaces: `~/AppData/Roaming/"Code - Insiders"/User/settings.json`
   3. First letter `D` → `chezmoi forget --force <path>`
   4. Anything else → `chezmoi add <path>`
4. Run Commit & push.
5. Run Status check and STOP if:
   1. not clean
6. AskUserQuestion: "Do you want to re-add these directories?" with options "Yes" / "No".
   1. No → done.
   2. Yes → `chezmoi add ~/.claude/skills/ ~/.claude/commands/ ~/.claude/agents/ ~/.claude/rules/ ~/.claude/output-styles/` (empty dirs get a `.keep` automatically)
7. Run Status check.
   1. Clean → done.
8. Run Commit & push.
9. Run Status check and STOP if:
   1. not clean
