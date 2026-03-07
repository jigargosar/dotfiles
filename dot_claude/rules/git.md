Git and GitHub Rules

# Git

- `git stash`: Always use `apply`, never `pop` — pop deletes the stash on success, losing the safety net
- Never use `-A` or `.` to stage files, always use explicit file names — never blanket add
- No Claude promotions in commits (no `Co-Authored-By`, no generated-by links) — ONLY sign off with "Committed by Claude" followed by the active model name (e.g., "Committed by Claude Opus 4.6")
- When processing commit request with multiple commands (diff, status, etc.), prefer chaining with `&&`
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` — NEVER use `git push` alone

# GitHub

- For GitHub username/repo: use git remote; if not found, ask user
- For GitHub Pages: use native actions/deploy-pages + configure via gh CLI API
