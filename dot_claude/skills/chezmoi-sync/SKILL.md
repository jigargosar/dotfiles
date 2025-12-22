---
name: chezmoi-sync
description: Sync chezmoi-managed target files back to source and push to remote. Use when user mentions chezmoi, pushing dotfiles, or after editing files like ~/.claude/CLAUDE.md
---

# Chezmoi Sync

## Instructions

1. Run `chezmoi status && chezmoi git -- status -s` - format output with headers (Chezmoi: / Git:), show "clean" if empty
2. Run `chezmoi diff > /dev/null 2>&1`
3. Run: `chezmoi add <files> && chezmoi git -- add <source-files> && chezmoi git -- commit -m "<concise message from context>" && chezmoi git -- push --follow-tags`

## Notes

- Use explicit file names from status output, never use `-A` or `.`
- Source files use chezmoi naming (e.g., `dot_claude/CLAUDE.md` for `~/.claude/CLAUDE.md`)