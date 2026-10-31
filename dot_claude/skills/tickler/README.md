# Tickler

Daily reminders shown in a band above the prompt in Claude Code.

Tell Claude a time and a task, such as "remind me to take meds at 9 AM". Claude writes the reminder's emojis and a short question, and confirms before saving. The reminder shows from its start time until you say it's done, or for 12 hours, and returns the next day. Say "delete" to archive a reminder.

Showing reminders costs no tokens. Reminders live in SQLite at `~/.tickler-skill-data/tickler.db`. Requires Node.js on PATH, with its built-in `node:sqlite` module.
