## When Presenting Options or Asking Questions

1. Always use numbered lists (1., 2., 3.) — never bullet points or unnumbered prose
2. Each option must be verified and valid — no flawed or inapplicable ones
3. Always include a recommendation — never present options without one
4. Before asking a question, check if the answer is obvious from project context
5. Never ask for confirmation of something you can verify yourself by reading code or config

## Response Discipline

- Terse and to the point by default. Only elaborate when explicitly asked.
- "discuss", "explain", "analyze", "investigate", "research" = TALK ONLY. Produce text. Never edit files, run builds, or invoke state-changing tools.
- No unsolicited observations, warnings, or commentary. Respond only to what was asked.
- Problem restatement = pure problem. Zero solution words — no "extract", "split", "move", "class", "module", "field". Describe what is wrong, not how to fix.
- Never state uncertain things as facts. Say "I believe" / "I'm not certain" when unsure. Never fabricate technical claims.
- When suggesting next steps, always provide specific options with recommendations — never a bare "Next?"

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

## Code Standards — must be followed when designing and writing code

- When auditing code against any standard, flag a violation if the code doesn't follow the principle. Don't discount violations because no harm has occurred yet or current code happens to avoid the problem.

- Make impossible states impossible (ISI) — for all data models and state
- Tell, don't ask — tell a module what you need, don't reach into its internal state or implementation. If cross-module data is needed, ask the owning module to create and expose a function for it.
- Single Source of Truth — every piece of data has exactly one authoritative source
- Principle of Least Privilege — only expose what's needed
- State transitions — validate current state before acting, don't assume validity from incoming events
- Always optimize for readability and simplicity — performance, memory efficiency, and dependency count are not important
- Identifier names must be clear enough that comments are unnecessary — reserve comments for explaining why, not what
- Primitive types must use domain-specific type aliases — `Age` not `number`, `NoteId` not `string`
- Type aliases are opaque to callers — never access underlying type or assume internal representation
- Abstractions are for decoupling and encapsulation, not for performance optimization
- No magic numbers
- Pass only what a function needs — prefer individual parameters over whole objects
- Always review your own suggestions before presenting — don't propose obviously flawed or silly solutions

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

- Bash: When running commands, don't use `cd /path &&` prefix or absolute paths - shell is already in project folder, use relative paths.
- Search: Respect `.gitignore` when searching and doing any file operations.
- Search: Relying on narrow search/grep terms may miss relevant files/content. Read full file contents when needed.
- Chrome MCP: After code changes, always hard refresh browser (Ctrl+Shift+R) before testing - don't rely on HMR/auto-reload.
- Don't run interactive commands - present a clear plan for user to run instead, don't skip steps you can't do
- Default to pnpm (infer from lockfile), not npm
- For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues
- When code changes aren't reflecting in the browser after multiple edits and you're confident the code is correct, proactively suggest restarting the dev server to clear cache issues
- Dev server as background task: only focus last few lines for error or success. When output grows too long, ask to restart dev server

## Delegation & Tool Invocation

- When user specifies which tool/skill to use, use exactly that — never substitute
- When delegating to an agent, pass the user's exact instructions — don't add own interpretation or extra directives
- Skill tool has its own template that overrides args — when exact prompt control matters, use Task tool instead

## Git

- `git stash`: Always use `apply`, never `pop` — pop deletes the stash on success, losing the safety net
- Never use `-A` or `.` to stage files, always use explicit file names - never blanket add
- Don't add Claude promotions to commits, just use "Committed by Claude"
- When processing commit request with multiple commands (diff, status, etc.), prefer chaining with `&&`
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` - NEVER use `git push` alone

## GitHub

- For GitHub username/repo: use git remote; if not found, ask user
- For GitHub Pages: use native actions/deploy-pages + configure via gh CLI API

## Chezmoi

- `chezmoi git` commands options need double hyphen, otherwise chezmoi will pick it up and cause errors
- After editing chezmoi-managed files (e.g., `~/.claude/CLAUDE.md`), invoke chezmoi-sync skill

## Board (docs/Board.md)

- Sections: Urgent, InBasket, Ready, InProgress, Done, Backlog
- New items go at top of their section
- Items can move between any sections
- When starting a task: ensure it is moved/added to InProgress
- When task completed: ensure it is moved to Done
- inbox/inbasket refer to same section
- When checking for duplicates or related items, read the ENTIRE file and check ALL sections

## Package Publishing

- When user asks to publish: discuss and recommend semver level (patch/minor/major)
- Never assume what semver to use, always double check
- Run `npm version [level] && git push --tags`
- NEVER run `npm publish`, unless explicitly asked

## Elm Packages

- Package URL root: `https://package.elm-lang.org/packages/`
- Install: `echo "Y" | elm install <package-name>`
- Source root: `%APPDATA%\elm\0.19.1\packages\`

## Elm Programming Language

- Compilation MUST use `elm make src/Main.elm --output=NUL`.
- Use multiple class attributes, never do string concatenation.
- Never duplicate static classes, use multiple class attributes.
- Models MUST strictly follow `Make Invalid States Impossible` principle.
- Long class strings MUST be split into multiple class attributes.
- Avoid catch-all (`_`) case branches even if code duplicates across branches. Extract to helper when 3+ branches share identical body. Use catch-all only when 5+ branches share identical body.
- Expose types from imports rather than using qualified module names for types


## Library-Specific Usage Rules

- fractional-indexing: Never use `localeCompare` for sorting - use plain `<` / `>` comparison
- Tailwind v4: don't use outdated knowledge — always use current v4 syntax and conventions

## Code Smells to Avoid

- Use `switch` with `assertNever` for type discrimination, never `if/else` chains - ensures exhaustive checking at compile time

## Documentation Formatting

- No H1 headings in files — use plain text for document title, start sections with #

ASCII tables (default, use instead of markdown tables):
- Max width: 100 chars
- Header borders: `=`, data borders: `-`
- Word wrap: split long content across rows with empty cells
- Include row number column
- 1 char padding around cell content

Example:
```
+-----+================+================+
| #   | Header 1       | Header 2       |
+-----+================+================+
| 1   | short data     | short data     |
+-----+----------------+----------------+
| 2   | long content   | more content,  |
|     | wrapped here   | also wrapped   |
+-----+----------------+----------------+
```

## Code Analysis for Extraction/Refactoring

<!-- TODO: Move to dedicated agent/skill/command when appropriate -->

- Read line by line, no preconceptions about what belongs where
- Ask what code does, not what it currently touches - signatures are accidents of history
- Every location must be justified, not inherited - "it's already here" is not justification
- Coupling claims require evidence - show *why*, not just that types are referenced
- Parameters can be reshaped - analyze the operation, not current signature
- Small extractions have value - cognitive load is cumulative
- Distinguish orchestration (when/wiring) from implementation (what/domain)

## TypeScript Projects

- After a major change, run lint, build, and tests

## Debugging

- Dev server: When changes aren't reflecting after hard refresh, check if a stale dev server process is running on the port (`netstat -ano | grep <port>`) — kill it and restart. A stale process won't pick up file changes.

## Chrome MCP Fix (Windows)

Bug in Claude Code on Windows: socket discovery function in minified `cli.js` misses Windows named pipes. Function names change per version — see project memory for current names and patching approach. Re-apply after updates. Issue: #22983