# Bash Rules

1. Never use `echo` with `---` — triggers hook rejection. Use `echo ===` as separator instead
3. Never use `$()` subshell substitution — use plain strings
4. Never use heredoc/EOF syntax — use `-m` with quoted strings instead. Escape special characters as needed.
5. Never use interactive flags (`-i`)
6. Chain related commands together with `&&` — don't separate into multiple tool calls without reason
