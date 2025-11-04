# Commit Protocol

## Git Commit Instructions
- Never use `-A` or `.` to stage files, always use explicit file names - never blanket add
- Don't add Claude promotions to commits, just use "Committed by Claude"
- When processing commit request with multiple commands (diff, status, etc.), prefer chaining with `&&`
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` - NEVER use `git push` alone

## Additional Git Context
- For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues

## Chezmoi-specific
- `chezmoi git` commands options need double hyphen, otherwise chezmoi will pick it up and cause errors