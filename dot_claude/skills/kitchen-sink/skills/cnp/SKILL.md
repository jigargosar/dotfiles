---
name: cnp
description: Commit and Push when user says cnp
disable-model-invocation: false
user-invocable: false
model: Haiku
---

- Use `git add <file1> [<file2> ...] && git commit -m "<msg>" && git push --follow-tags`.
- including untracked changes.
- Never `git add -A` or `git add .`.
- Don't pause for a separate confirmation before running it.
- Stage only your changes. User gets to override.
