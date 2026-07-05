---
name: language-markdown
description: Markdown formatting guardrails.
when_to_use: Authoring markdown.
user-invocable: false
disable-model-invocation: false
paths: ["**/*.md", "**/*.markdown"]
---

# Markdown formatting rules

1. No bold formatting — no `**text**`, no `__text__`, no bold as a pseudo-heading.
2. Number every list item, in serial, unique, and continuous across the whole file — never resetting per section.
3. Mark a label or term with a trailing colon: `label: text`.

# Tables

4. For a table that must stay readable in raw source (not just rendered), don't hand-author a pipe table or an ASCII box-table. Run `node <skill-dir>/table.js input.json` (or pipe JSON via stdin) — pass `{"headers": [...], "rows": [[...], ...], "widths": [...]}` (`widths` optional, auto-computed if omitted). It wraps long cells, pads every column to a fixed width, and verifies alignment before printing, so the result is guaranteed correct. Embed its output in a fenced code block.
5. Every table row gets a serial-number `#` column so it's individually addressable — this is rule 2 applied to tables. `table.js` adds it automatically (`numbered: true` by default); pass `"start": N` to continue the count from a numbered list earlier in the same file instead of resetting to 1.
