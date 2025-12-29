---
name: inbox
description: "Process Inbox tasks in ROADMAP.md - triage by moving or modifying. Invoke with /inbox or 'process inbox'. Present each task one at a time with move options (Inbox, Ready, In Progress, Pending Review, Done, Backlog), auto-detected suggestions (merge, split, rename), and Reassess option for deeper analysis. Also supports processing other sections: 'process ready', 'process backlog', etc."
---

# When Processing Inbox:

Read ROADMAP.md. Present ONE task at a time with options and recommendation. Wait for user response before proceeding to next.

```
**[Task name]**

a. Inbox (current)
b. Ready
c. In Progress
d. Pending Review
e. Done
f. Backlog
g. [Auto-detected suggestions if applicable, continue h, i...]
R. Reassess...
```

# Auto-detected Suggestions

When suggesting merge, split, rename, or other modifications, always show a preview:

```
g. Merge with "other task name"
   Preview: `- [merged task text]`
```

# Processing Other Sections

Same workflow as "When Processing Inbox" applies. Invoke with "process ready", "process backlog", etc. Mark current section with "(current)" in options.

# Notes
- Template: Ensure ROADMAP.md exist at project root, else copy from `templates/ROADMAP.md`.
- Tone: Be concise but friendly. Avoid unnecessary verbosity.

