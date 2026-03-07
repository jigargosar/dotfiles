# Bash Rules

1. Never use `cd` — it changes shell state and causes wrong-repo mistakes
2. Never use `echo` or quoted strings containing `---` — triggers hook rejection
3. Never use `$()` subshell substitution — use plain strings
4. Never use heredoc/EOF syntax — use `-m` with quoted strings instead. Escape special characters as needed.
5. Never use interactive flags (`-i`)
6. Chain related commands together with `&&` — don't separate into multiple tool calls without reason
