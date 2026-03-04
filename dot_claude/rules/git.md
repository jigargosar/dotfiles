Git and GitHub Rules

# Git

- `git stash`: Always use `apply`, never `pop` — pop deletes the stash on success, losing the safety net
- Never use `-A` or `.` to stage files, always use explicit file names — never blanket add
- Don't add Claude promotions to commits, just use "Committed by Claude"
- When processing commit request with multiple commands (diff, status, etc.), prefer chaining with `&&`
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` — NEVER use `git push` alone

# GitHub

- For GitHub username/repo: use git remote; if not found, ask user
- For GitHub Pages: use native actions/deploy-pages + configure via gh CLI API
