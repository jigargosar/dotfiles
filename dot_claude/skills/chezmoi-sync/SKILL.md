---
name: chezmoi-sync
description: Sync chezmoi-managed target files back to source and push to remote. Use when user mentions chezmoi, pushing dotfiles, or after editing files like ~/.claude/CLAUDE.md
disable-model-invocation: false
user-invokable: true
---

# Chezmoi Sync

## Instructions

1. Run `chezmoi status && chezmoi git -- status -s`, show formatted output:

   Chezmoi:
   <raw output or "clean">

   Git:
   <raw output or "clean">

2. Show output before running next command
3. Run `chezmoi diff > /dev/null 2>&1`
4. Run: `chezmoi add <files> && chezmoi git -- add <source-files> && chezmoi git -- commit -m "<concise message from context>" && chezmoi git -- push --follow-tags`
5. Run `chezmoi status && chezmoi git -- status -s` again to verify clean state

## Notes

- Run commands EXACTLY as written — do not split chained (&&) commands into separate calls
- Always show output before running next command
- Use explicit file names from status output, never use `-A` or `.`
- Source files use chezmoi naming (e.g., `dot_claude/CLAUDE.md` for `~/.claude/CLAUDE.md`)
- Include ALL files from chezmoi status in the add command, not just the ones related to current task
- For deleted files (DA status): use `chezmoi forget --force <target-path>` to remove from source without interactive prompt