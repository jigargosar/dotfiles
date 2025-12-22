---
name: chezmoi-sync
description: Sync chezmoi-managed target files back to source and push to remote. Use when user mentions chezmoi, pushing dotfiles, or after editing files like ~/.claude/CLAUDE.md
---

# Chezmoi Sync

## Instructions

1. Run `chezmoi status && chezmoi git -- status` to check for changes
2. Summarize status cleanly (e.g., "Modified: ~/.claude/CLAUDE.md, Git: up to date")
3. If targets modified, ask user if they want to see diff before proceeding
4. If user wants diff, run `chezmoi diff` - let output flow to terminal, don't process it
5. After diff (or if skipped), proceed directly with sync - no second confirmation needed
6. Generate a concise commit message from conversation context
7. Run: `chezmoi add <files> && chezmoi git -- add <source-files> && chezmoi git -- commit -m "<message>" && chezmoi git -- push --follow-tags`

## Notes

- Use explicit file names from status output, never use `-A` or `.`
- Source files use chezmoi naming (e.g., `dot_claude/CLAUDE.md` for `~/.claude/CLAUDE.md`)
- Commit message should reflect what was changed, keep it brief
- Always use `--follow-tags` when pushing