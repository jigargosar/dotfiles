---
name: skill-init
description: Help user create a new Claude Code skill.
disable-model-invocation: true
---


# Reference Skill dirs  
- Personal: `~/.claude/skills/<skill-name>/SKILL.md`
- Project: `.claude/skills/<skill-name>/SKILL.md`
- No need to hunt down skill folders, name.


# Frontmatter Reference

All fields are optional. Place between `---` markers at top of SKILL.md.

+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| #   | Field                      | Type    | Default         | Description                                                |
+-----+============================+=========+=================+============================================================+
| 1   | `name`                     | string  | directory name  | Slash command name. Lowercase, numbers, hyphens only.      |
|     |                            |         |                 | Max 64 chars.                                              |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 2   | `description`              | string  | first paragraph | What skill does and when to trigger. Claude uses this      |
|     |                            |         |                 | for auto-invocation.                                       |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 3   | `disable-model-invocation` | boolean | `false`         | `true` = only user can invoke via `/name`. Claude          |
|     |                            |         |                 | won't auto-trigger.                                        |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 4   | `user-invocable`           | boolean | `true`          | `false` = hidden from `/` menu. Only Claude can invoke     |
|     |                            |         |                 | automatically.                                             |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 5   | `allowed-tools`            | string  | —               | Tools Claude can use without permission.                   |
|     |                            |         |                 | e.g. `Read, Grep, Glob`.                                   |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 6   | `model`                    | string  | —               | Model override when skill is active.                       |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 7   | `context`                  | string  | —               | Set to `fork` to run in isolated subagent context.         |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 8   | `agent`                    | string  | —               | Subagent type when `context: fork`. Options: `Explore`,    |
|     |                            |         |                 | `Plan`, `general-purpose`.                                 |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+
| 9   | `hooks`                    | object  | —               | Hooks scoped to this skill's lifecycle.                    |
+-----+----------------------------+---------+-----------------+------------------------------------------------------------+

# Skill Creation Workflow

1. "What should the skill be named? (This becomes `/your-name`)"
2. "Personal (all projects) or project (this project only)?"
3. "Describe what this skill does — Claude uses this to decide when to auto-invoke it."
4. Show the frontmatter table above. "Which options do you want to set? (refer by row number, or 'none' for defaults)"
5. "What instructions should Claude follow when this skill is invoked?"
6. Create `<scope-dir>/skills/<skill-name>/SKILL.md` with frontmatter and content.
7. "Created `/name`. Try it out with `/name`."
