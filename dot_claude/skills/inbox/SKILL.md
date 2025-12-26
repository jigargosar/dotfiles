---
name: inbox
description: "Process Inbox tasks in ROADMAP.md - triage by moving or modifying. Invoke with /inbox or 'process inbox'. Present each task one at a time with move options (Inbox, Ready, In Progress, Pending Review, Done, Backlog), auto-detected suggestions (merge, split, rename), and Reassess option for deeper analysis. Also supports processing other sections: 'process ready', 'process backlog', etc."
---

# When Processing Inbox:

Read ROADMAP.md. For each Inbox task, present options and recommendation:

```
**[Task name]**

1. Inbox (current)
2. Ready
3. In Progress
4. Pending Review
5. Done
6. Backlog
7+ [Auto-detected suggestions if applicable]
N. Reassess...
```

# Processing Other Sections

Same workflow as "When Processing Inbox" applies. Invoke with "process ready", "process backlog", etc. Mark current section with "(current)" in options.

# Notes
- Template: Ensure ROADMAP.md exist at project root, else copy from `templates/ROADMAP.md`.
- Tone: Be concise but friendly. Avoid unnecessary verbosity.

