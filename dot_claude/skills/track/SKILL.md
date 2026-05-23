---
name: track
description: |
  Creates new tasks using TaskCreate tool. And also ensuring all existing task titles are numbered.
disable-model-invocation: false
user-invocable: true
model: inherit
---

1. Create a task or list from $ARGUMENTS
2. Ensure all tasks are prefixed with numbers.
3. Format: `{number}. {title}` — e.g., `1. Set up component structure`
