---
name: claude-code-knowledge-patch
description: >-
  Knowledge patch for SKILL.md frontmatter and skills-directory plugins.
when_to_use: >-
  When creating or modifying a skill.
user-invocable: true
disable-model-invocation: false
paths: "**/SKILL.md"
---

# SKILL.md frontmatter fields

Always set: name, description, when_to_use, user-invocable, disable-model-invocation, paths, even when we are stating defaults.

## General
- name — display label
- description — describe what it does
- when_to_use — when should the skill be triggered
- user-invocable — default true; false hides it from the `/` menu
- disable-model-invocation — default false; true makes it manual-only (`/name`)
- paths — Glob patterns that limit when this skill is activated. Accepts a comma-separated string or a YAML list. When set, Claude loads the skill automatically only when working with files matching the patterns.

---

## Advanced
- allowed-tools — grants the listed tools no-prompt use while the skill is active. Not a whitelist: unlisted tools stay callable under normal permissions. For project skills, applies only after workspace trust.
- disallowed-tools — tools removed from the pool while the skill is active
- arguments — named positional args for `$name` substitution
- model — model override
- context: fork (+ agent) — run the skill in an isolated subagent

Ref: https://code.claude.com/docs/en/skills#frontmatter-reference

---

# Skills-directory plugins
- Apart from marketplace plugins, there is another path where user can place plugins.
- In skills folder .claude/skills/my-plug-skill/`entire plugin structure` can be created.
- This helps user to create their own plugins, organize, and perhaps later promote it.

- Ref: https://code.claude.com/docs/en/plugins-reference#skills-directory-plugins