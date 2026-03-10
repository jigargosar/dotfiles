---
name: command-init
description: Helps creating custom slash commands.
disable-model-invocation: true
user-invocable: true
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
model: claude-haiku-4-5-20251001
---


# Command Directories

- Personal: `~/.claude/commands/<name>.md`
- Project: `.claude/commands/<name>.md`

Commands are single `.md` files. The filename (without extension) becomes the `/slash-command` name.

# Format

Commands can be plain markdown or include optional frontmatter:

```
---
description: What this command does
user-invocable: true
disable-model-invocation: false
---

Your instructions here...
```

Frontmatter is optional. Without it, the file is just plain markdown instructions.

# Command Creation Workflow

1. "What should the command be named? (This becomes `/your-name`)"
2. "Personal (all projects) or project (this project only)?"
3. "What should this command do? Describe the instructions Claude should follow when `/name` is invoked."
4. Create `<scope-dir>/commands/<name>.md` with the content.
5. "Created `/name`. Try it out with `/name`."
