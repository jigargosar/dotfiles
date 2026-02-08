# Claude Instructions Summary

When asking questions — even binary ones — always present numbered options in a list. Example:
  Bad: "Want me to proceed with writing the full plan file, or adjust further?"
  Good:
    1. Proceed with writing the full plan file (recommended)
    2. Adjust further

## When Presenting Options or Asking Questions

When presenting suggestions, options, alternatives, or asking questions:
1. Always use numbered lists (1., 2., 3.) — never bullet points or unnumbered prose
2. Each option must be verified and valid — no flawed or inapplicable ones
3. Always include a recommendation — never present options without one

## Workflow Guidelines

- Only do what's explicitly asked, nothing more/less - discuss additional work first
- Always present implementation plan for approval before implementing
- Always read and understand the full function/context before modifying code
- Refactor before modifying — when touching legacy code for a fix, improve names/structure first, then make the change
- Don't keep jumping to implementation without thinking through the design first
- When 2-3 solutions rejected OR user asks to "think again"/"rethink" 2-3 times, STOP guessing. Ask user with this exact message:
    "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of? That would be more efficient than me continuing to guess."
- Be concise but complete, not super verbose
- When asked to "add todo:" just add it, no discussion needed - focus on current discussion
- When my request is incorrect or can't be fulfilled, don't proceed without explicit confirmation
- Always get approval before implementing; deviations from agreed plans require explicit discussion and permission
- When user is straying off path, not focusing on core problem, or getting finicky, say this exact message:
    "You might be going down a rabbit hole. Want to refocus on the main objective?"

## Code Quality

- Make impossible states impossible (ISI) for data models
- Default design must always focus on Single Source of Truth
- Principle of Least Privilege - only expose what's needed
- Focus on readability over performance (warn only about exponential increases)
- Want simpler solutions across functions, not blind single-function improvements
- By symmetry: keep child elements similar level of abstraction, prefer extraction of methods
- Don't worry about memory-heavy for large states unless exponentially costly - simplicity wins by default
- Don't add obvious comments where identifier name is clear
- Always prefer type aliases even for basic types (e.g., `Set(RowIdx, ColIdx)` not `Set(Int, Int)`)
- Never suggest internal implementation details to callers (Set.empty, Dict.empty, raw tuples, etc.)
- When a module uses type alias for its model, clients must treat it as opaque - type aliases are implementation choice, encapsulation is design principle
- Abstractions and precomputed configs are for decoupling/encapsulation, not optimization

## General Instructions

- Workflow: Always prefer editing existing files over creating new ones
- Error Handling: Never swallow/rethrow same exceptions - let them propagate to top level to fail fast
- Error Handling: **Exception:** Handle the case properly if needed for logical flow
- File Paths: Use file names relative to current project workspace
- File Paths: ALWAYS use workspace-relative paths for project files - NEVER use absolute Windows paths or `/mnt/c/` WSL paths.
- File Paths: For simple renaming, use grep/sed etc., don't waste tokens unless refactoring is tricky
- File Paths: Ignore reference directory unless explicitly asked to look into it
- File Paths: When file write fails repeatedly due to "unexpectedly modified" errors, retry using Windows path format
- Tools: Don't run interactive commands - present a clear plan for user to run instead, don't skip steps you can't do
- Tools: Default to pnpm (infer from lockfile), not npm
- Tools: For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues
- Package Management: if and when manually creating package.json file, ensure all dependencies are installed via package manager, don't hardcode them.
- Focus: Fixing subtle duplications or unnecessary indirection may help uncover major duplications that were previously hidden - jumping to tackle major duplication upfront isn't always the right approach, analyze carefully.
- Design: When designing, avoid margin, and prefer padding. especially for vertical alignment. It's ok to use margin auto for centering horizontally

## Tools

- Bash: When running commands, don't use `cd /path &&` prefix or absolute paths - shell is already in project folder, use relative paths.
- Search: Respect `.gitignore` when searching and doing any file operations.
- Search: Relying on narrow search/grep terms may miss relevant files/content. Read full file contents when needed.
- Chrome MCP: After code changes, always hard refresh browser (Ctrl+Shift+R) before testing - don't rely on HMR/auto-reload.

## Git

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

## When in Plan Mode

Ensure task is in ROADMAP.md "In Progress" section.

## When Task Completed

When user confirms task is done, move it from "In Progress" or "Pending Review" to "Done" in ROADMAP.md.

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


## Library-Specific Usage Rules

- fractional-indexing: Never use `localeCompare` for sorting - use plain `<` / `>` comparison

## Code Smells to Avoid

- Use `switch` with `assertNever` for type discrimination, never `if/else` chains - ensures exhaustive checking at compile time

## Documentation Formatting

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

## Miscellaneous Instructions
- in typescript projects after a major change, always run lint and build
- in typescript projects after a major change, always run lint and build and also tests
- only after a major change in code you shuld run lint build and test
- your are too verbose, keep them brief and to the point.
- When code changes aren't reflecting in the browser after multiple edits and you're confident the code is correct, proactively suggest restarting the dev server to clear cache issues.
- if you are running dev server as background task, only focus last few for error or success. when output grows too long, ask to restart deverserver
- dont use magic numbers, specially when writing new code.
- when working with tailwind v4 (which we do almost always) dont use outdated knowledge.
- when asking next you should provide suggetsions and recommendations, Never just blanket `Next?`
- never hand code dependencies verison in package.json, we have pnpm install command for that. Dont be oversmart.
- always review your code for silly mistakes, before presenting to user.
- In Elm, try to expose types from imports rather than using qualified module names for types
- keep your responses terse and very brief, unless explictly asked to elobrate. prompts like `discuss` and `explain` should also be very focused. unless explictly asked to eloborate.
- keep responses extremely terse, for the entire conversation
- never pass more data that whats required to target function, unless target functinn needs many arguments all present is passed object.
- dont perform any actions whitout permission, when I  asked a question, just reply dont infer it as permission to edit. I dont ask rhetorical questions
- Responses should be terse, and to the point,
- no silly questions 
 
- we need to ensure that state transitions only happen when current state is valid, just because an msg was received, we cant assume model
   is in correct state. 
- you should never revert code, ask me to do so 
- you need to remind me to stop when I go down a rabbit hole.

## Chrome MCP Fix (Windows)

Bug in Claude Code v2.1.20+: `ro4()` in `cli.js` misses Windows named pipes. Fix: add `if(lmY()==="win32")return[\`\\\\.\\pipe\\${smY()}\`]` at start of `ro4()`. Re-apply after updates. Issue: #22983