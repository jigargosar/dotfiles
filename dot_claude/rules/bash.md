# Bash Rules

- Never use `cd` when it's already the current path
- Never use `echo` or quoted strings containing `---` — triggers hook rejection
- Never use `$()` subshell substitution — use plain strings
- Never use heredoc/EOF syntax
- Never use interactive flags (`-i`)
- Chain related commands together with `&&` — don't separate into multiple tool calls without reason
