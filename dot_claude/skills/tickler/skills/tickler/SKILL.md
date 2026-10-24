---
name: tickler
description: Daily reminders shown above the prompt. Use when the user says they did a reminder's task (such as "meds taken"), or asks to add, list, change, or delete a reminder.
---

1. Call `mcp__tickler__list` to see the reminders, their ids, and which are showing.
2. Match the user's words to a reminder. If more than one could match, offer them all in the confirm.
3. Confirm every change with AskUserQuestion, then call `mcp__tickler__done`, `add`, `edit`, or `archive`.
4. Delete means archive. The reminder is gone for the user, and its row stays as a backup.

Keep every reply to one short line. No headings, lists, or TLDR.

- Confirm: AskUserQuestion `Mark 💊🌅 9 AM and 💊☕ 11 AM done?`
- After: `Done ✓`
- Add: AskUserQuestion `Add 💊🌅 "Morning meds down?" daily 9 AM?` then `Added ✓`
