---
name: chezmoi-sync
description: Sync chezmoi-managed target files back to source and push to remote. Use when user mentions chezmoi, pushing dotfiles, or after editing files like ~/.claude/CLAUDE.md
disable-model-invocation: true
user-invokable: true
model: inherit
allowed-tools:
  - Bash(mkdir -p ~/.claude/skills/ ~/.claude/commands/ ~/.claude/agents/ ~/.claude/rules/ ~/.claude/output-styles/)
---

Run Workflow: Sync, then Workflow: Re-add.

# Workflow: Sync

1. Run `chezmoi status && echo "==GIT==" && chezmoi git -- status -s`, show formatted output:

   Chezmoi:
   <raw output or "clean">

   Git:
   <raw output or "clean">

2. If git status is not clean, STOP immediately, ask user how to proceed — NEVER proceed automatically
3. Show output before running next command
4. Run `chezmoi diff > /dev/null 2>&1` with run_in_background: true. Then STOP. If exit code is not 0, STOP immediately, ask user how to proceed — NEVER proceed automatically
5. Run: `chezmoi add <files> && chezmoi git -- add <source-files> && chezmoi git -- commit -m "<concise message from context>" && chezmoi git -- push --follow-tags`
6. Run `chezmoi status && echo "==GIT==" && chezmoi git -- status -s` — if not clean, STOP immediately, ask user how to proceed — NEVER proceed automatically

# Workflow: Re-add

7. Run `mkdir -p ~/.claude/skills/ ~/.claude/commands/ ~/.claude/agents/ ~/.claude/rules/ ~/.claude/output-styles/`
   Use AskUserQuestion to ask: "Do you want to re-add these directories?"
   Options: "Yes" (re-add all), "No" (skip and finish)
   If yes, run `chezmoi add ~/.claude/skills/ ~/.claude/commands/ ~/.claude/agents/ ~/.claude/rules/ ~/.claude/output-styles/`
8. Run `chezmoi status && echo "==GIT==" && chezmoi git -- status -s` — if both clean, done
9. Run: `chezmoi git -- add <source-files> && chezmoi git -- commit -m "<concise message from context>" && chezmoi git -- push --follow-tags`
10. Run `chezmoi status && echo "==GIT==" && chezmoi git -- status -s` — if not clean, STOP immediately, ask user how to proceed — NEVER proceed automatically

# Notes

- NEVER use `chezmoi apply` — it overwrites target files with source state, causing complete data loss.
- Run commands EXACTLY as written — do not split chained (&&) commands into separate calls
- Always show output before running next command
- Use explicit file names from status output, never use `-A` or `.`
- Source files use chezmoi naming (e.g., `dot_claude/CLAUDE.md` for `~/.claude/CLAUDE.md`)
- Include ALL files from chezmoi status in the add command, not just the ones related to current task
- For deleted files (DA status): use `chezmoi forget --force <target-path>` to remove from source without interactive prompt
- `chezmoi git` command options need double hyphen, otherwise chezmoi will pick it up and cause errors
- **These commands must be run in Bash, not PowerShell** — PowerShell path handling differs and is not covered here.
- Paths with spaces: use partial quoting — quote only the space-containing segment, leaving `~` unquoted: `~/AppData/Roaming/"Code - Insiders"/User/settings.json`. This applies to all chezmoi and `chezmoi git --` commands.
