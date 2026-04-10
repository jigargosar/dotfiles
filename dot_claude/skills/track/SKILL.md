---
name: track
description: |
  Creates tasks using TaskCreate tool and renumbers them
  by prefixing a number to each task.
disable-model-invocation: true
---

# Instructions

When invoked with `/track`, manage numbered tasks using the TaskCreate tool.

## Creating Tasks

1. Accept a list of tasks from the user's arguments or conversation context.
2. Create each task using TaskCreate, prefixing its description with a sequential number.
3. Format: `{number}. {description}` — e.g., `1. Set up component structure`
