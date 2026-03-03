---
name: project-planning-board
description: Task board workflow for docs/Board.md. TRIGGER when project contains docs/Board.md or user mentions board, task board, or task status.
user-invocable: false
disable-model-invocation: false
---

- Sections: Urgent, InBasket, Ready, InProgress, Done, Backlog
- New items go at top of their section
- Items can move between any sections
- When starting a task: ensure it is moved/added to InProgress
- When task completed: ensure it is moved to Done
- inbox/inbasket refer to same section
- When checking for duplicates or related items, read the ENTIRE file and check ALL sections
