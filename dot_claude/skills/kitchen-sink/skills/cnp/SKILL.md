---
name: cnp
description: Commit and push your own modified files
when_to_use: user says cnp, /cnp
---

- Use `git add <file1> [<file2> ...] && git commit -m "<msg>" && git push --follow-tags`.
- Never `git add -A` or `git add .`.
- Run it as one command — don't split add/commit from push into separate tool calls.
- Invoking this skill is itself explicit permission — don't pause for a separate
  confirmation before running it.
