## Code Philosophy

Code is written for humans — every decision must minimize cognitive effort for the reader (see code-standards.md).

## Workflow Guidelines

- Only do what's explicitly asked, nothing more/less. To propose additional work, discuss it first — don't just do it.
- Investigation/research: survey ALL areas/responsibilities breadth-first before diving into any single one.
- Questions are not permission to act. When user asks a question, reply with text — don't infer it as permission to edit.
- Never revert code — ask user to do so.
- Always present implementation plan for approval before implementing
- Always read and understand the full function/context before modifying code
- Refactor before modifying — when touching legacy code for a fix, improve names/structure first, then make the change
- Don't keep jumping to implementation without thinking through the design first
- When 2-3 solutions rejected OR user asks to "think again"/"rethink" 2-3 times, STOP guessing. Ask user with this exact message:
    "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of? That would be more efficient than me continuing to guess."
- When my request is incorrect or can't be fulfilled, don't proceed without explicit confirmation
- Always get approval before implementing; deviations from agreed plans require explicit discussion and permission
- When user is straying off path, not focusing on core problem, or getting finicky, say this exact message:
    "You might be going down a rabbit hole. Want to refocus on the main objective?"

## General Instructions

- Workflow: Always prefer editing existing files over creating new ones
- Error Handling: Never swallow/rethrow same exceptions - let them propagate to top level to fail fast
- Error Handling: **Exception:** Handle the case properly if needed for logical flow
- Error Handling: Never leave promises floating — always attach .catch(console.error) for fire-and-forget, or await and let caller handle
- File Paths: ALWAYS use workspace-relative paths for project files - NEVER use absolute Windows paths or `/mnt/c/` WSL paths.
- File Paths: For simple renaming, use grep/sed etc., don't waste tokens unless refactoring is tricky
- File Paths: Ignore reference directory unless explicitly asked to look into it
- File Paths: When file write fails repeatedly due to "unexpectedly modified" errors, retry using Windows path format
- Focus: Fixing subtle duplications or unnecessary indirection may help uncover major duplications that were previously hidden - jumping to tackle major duplication upfront isn't always the right approach, analyze carefully.
- Design: When designing, avoid margin, and prefer padding. especially for vertical alignment. It's ok to use margin auto for centering horizontally

## Tools

- Search: Respect `.gitignore` when searching and doing any file operations.
- Search: Relying on narrow search/grep terms may miss relevant files/content. Read full file contents when needed.
- Chrome MCP: After code changes, always hard refresh browser (Ctrl+Shift+R) before testing - don't rely on HMR/auto-reload.
- Don't run interactive commands - present a clear plan for user to run instead, don't skip steps you can't do
- Default to pnpm (infer from lockfile), not npm
- For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues
- When code changes aren't reflecting in the browser after multiple edits and you're confident the code is correct, proactively suggest restarting the dev server to clear cache issues
- Dev server as background task: only focus last few lines for error or success. When output grows too long, ask to restart dev server

## Skills

- Invoke `language-elm` skill when project contains files with `.elm` extension
- Invoke `language-typescript` skill when project contains `tsconfig.json`
- Invoke `markdown-document-formatting` skill when creating or editing `.md` files
- Invoke `project-planning-board` skill when project contains `docs/Board.md`
- Invoke `chezmoi-sync` skill after editing chezmoi-managed files (e.g., `~/.claude/CLAUDE.md`)
- Invoke `fix-chrome-connection` skill when encountering browser extension connection failures
- Invoke `package-publishing` skill when user asks to publish, version, or release a package

## Gentle Reminders

- Refer to `bash.md` when executing Bash commands
- Refer to `code-standards.md` when writing or reviewing code
- Refer to `communication.md` when responding
- Refer to `git.md` when executing git commands

## Library-Specific Usage Rules

- fractional-indexing: Never use `localeCompare` for sorting - use plain `<` / `>` comparison
- Tailwind v4: don't use outdated knowledge — always use current v4 syntax and conventions


