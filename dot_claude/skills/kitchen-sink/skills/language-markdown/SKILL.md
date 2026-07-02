---
name: language-markdown
description: Markdown formatting guardrails.
when_to_use: Authoring markdown.
user-invocable: false
disable-model-invocation: false
paths: ["**/*.md", "**/*.markdown"]
model: haiku
---

# Markdown formatting rules

1. No bold formatting — no `**text**`, no `__text__`, no bold as a pseudo-heading.
2. Number every list item, in serial, unique, and continuous across the whole file — never resetting per section.
3. Mark a label or term with a trailing colon: `label: text`.
