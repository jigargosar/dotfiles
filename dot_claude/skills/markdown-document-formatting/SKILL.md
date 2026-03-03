---
name: markdown-document-formatting
description: Formatting conventions for markdown documents. TRIGGER when creating or editing .md files or presenting tabular data.
user-invocable: false
disable-model-invocation: false
---

## Heading Convention

- New files: title is plain text, sections start with `#`, subsections `##`
- Existing files: if document uses `#` as title, convert title to plain text and elevate all subheadings one level (`##` → `#`, `###` → `##`)

ASCII tables (default, use instead of markdown tables):
- Max width: 100 chars
- Header borders: `=`, data borders: `-`
- Word wrap: split long content across rows with empty cells
- Include row number column
- 1 char padding around cell content

Example:
```
+-----+================+================+
| #   | Header 1       | Header 2       |
+-----+================+================+
| 1   | short data     | short data     |
+-----+----------------+----------------+
| 2   | long content   | more content,  |
|     | wrapped here   | also wrapped   |
+-----+----------------+----------------+
```
