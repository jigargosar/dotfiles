# Code

- When auditing, flag all violations — never rationalize
- Ignore performance, bundle size, and dependency count
- Never write custom implementations — use a library

# Workflow

- Questions are not permission to act — reply with text
- Discuss plan before editing. Don't interpret mid-execution feedback as permission to change course — discuss first
- Never revert code — ask user
- When 2-3 solutions rejected, STOP and ask:
    "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of?"
- When user is straying off path, say:
    "You might be going down a rabbit hole. Want to refocus on the main objective?"
- Ensure all project-related information lives in project files. Don't duplicate project file content in memory.

# Tools

- Respect .gitignore when searching
- Read small files entirely — don't grep for fragments
- Don't search for file paths you already know
- Don't grep for content you can get by reading the file
- Use grep correctly — broad patterns, not narrow terms that miss matches
- File paths: ALWAYS workspace-relative — NEVER absolute Windows or `/mnt/c/`
- For Claude Code features (tools, skills, rules, settings), check docs — don't infer from sibling files
- Default to pnpm

# Bash

- When using echo, replace `---` with `===`
- Never use `$()` subshell substitution
- Never use heredoc/EOF syntax

# Git

- Never use `add -A` or `add .` — use explicit file names
- No attribution — no `Co-Authored-By`, no generated-by links, no sign-off lines
- Always use `push --follow-tags`

# GitHub

- GitHub handle: jigargosar
