# Claude Instructions Summary

## General Workflow
- Always present implementation plan for approval before implementing
- Use numbered/lettered prefixes with proper formatting when presenting options
- Always prefer editing existing files over creating new ones
- Only do what's explicitly asked, nothing more/less - discuss additional work first
- Don't keep jumping to implementation without thinking through the design first
- If 2-3 solutions rejected, ask user to share their approach:
  > "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of? That would be more efficient than me continuing to guess."

## Code Quality & Design
- Make impossible states impossible (ISI) for data models
- Default design must always focus on Single Source of Truth
- Focus on readability over performance (warn only about exponential increases)
- Want simpler solutions across functions, not blind single-function improvements
- By symmetry: keep child elements similar level of abstraction, prefer extraction of methods
- Don't worry about memory-heavy for large states unless exponentially costly - simplicity wins by default
- Don't add obvious comments where identifier name is clear
- Always prefer type aliases even for basic types (e.g., `Set(RowIdx, ColIdx)` not `Set(Int, Int)`)
- Never suggest internal implementation details to callers (Set.empty, Dict.empty, raw tuples, etc.)
- When a module uses type alias for its model, clients must treat it as opaque - type aliases are implementation choice, encapsulation is design principle
- Abstractions and precomputed configs are for decoupling/encapsulation, not optimization

## Error Handling
- Never swallow/rethrow same exceptions - let them propagate to top level to fail fast
- **Exception:** Handle the case properly if needed for logical flow

## Communication
- Be concise but complete, not super verbose
- Don't present silly/obviously wrong answers
- Always present recommended solution
- When asked to "add todo:" just add it, no discussion needed - focus on current discussion

## File & Path Usage
- Don't use cd command or absolute paths when files are relative to workspace
- Use file names relative to current project workspace
- For simple renaming, use grep/sed etc., don't waste tokens unless refactoring is tricky
- Ignore reference directory unless explicitly asked to look into it

## Tool/Command Usage
- Don't run interactive commands - present a clear plan for user to run instead, don't skip steps you can't do
- Default to pnpm (infer from lockfile), not npm
- For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues

## Git
- Never use `-A` or `.` to stage files, always use explicit file names - never blanket add
- Don't add Claude promotions to commits, just use "Committed by Claude"
- When processing commit request with multiple commands (diff, status, etc.), prefer chaining with `&&`

## Chezmoi
- `chezmoi git` commands options need double hyphen, otherwise chezmoi will pick it up and cause errors

## Package Publishing
- When user asks to publish: discuss and recommend semver level (patch/minor/major)
- Never assume what semver to use, always double check
- Run `npm version [level] && git push --tags`
- NEVER run `npm publish`, unless explicitly asked

## Prettier Config
- When user asks to install prettier, and it's not installed: install using inferred package manager as dev dependency
- If package manager cannot be inferred, use pnpm
- Ensure prettier config exists in package.json, if not found use default below - if found don't modify it:
```
"prettier": {
  "semi": false,
  "singleQuote": true,
  "trailingComma": "all",
  "endOfLine": "lf"
}
```

## Elm-Specific
- Always check compilation with exactly this command `elm make <file> --output=NUL`. Don't invent your own.
- Never use `--output=elm.js` or similar - we only want to verify compilation, not create artifacts

## Elm formatting rules

### Purpose
These rules are for AI/code agents making edits or updates. Adhere to these rules so that when elm-format runs, your edits will not be unexpectedly changed or invalidated. Review and re-read your code after formatting to ensure it matches these rules.

### Indentation & Spacing
- Indent with 4 spaces per level (no tabs).
- Two blank lines between top-level declarations (functions, type aliases, types).
- No trailing whitespace at the end of lines.
- If a line ends with `=`, the value or body always starts on a new line, indented.

### Records
- For any record (type alias, record literal, etc.):
    - Flat, single-line style and multiline style are both valid.
    - Flat style: `{ a : Int, b : String, c : Bool }`
    - Multiline style: each field on its own line, indented, with closing `}` on its own line.

### Type Declarations
- Type aliases and custom types use PascalCase.
- For custom types, each constructor is indented on its own line.

### Function Definitions
- Function signatures and bodies are indented and placed on a new line after the `=` sign.
- Use `let ... in` for local bindings, with the `in` keyword on a new line.

### Case Statements
- `case ... of` is used for pattern matching, with each branch indented.
- Each branch is formatted as:
    - Pattern followed by `->` on its own line
    - Result indented on the next line
    - A single blank line is placed between branches



## Miscellaneous Instructions
- if and when manually creating package.json file, ensure all dependencies are installed via package manager, dont hardcode them.
- if my request is incorrect, can't be fulfilled don't proceed ahead without explicit confirmation.
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` - NEVER use `git push` alone
- ALWAYS use workspace-relative paths for project files - NEVER use absolute Windows paths or `/mnt/c/` WSL paths.
- In Elm, when needed, try using multiple class attributes, to group sementaic classes together, so its easy to read and also not having to read a long list of classes.
- If I am straying off path, not focusing on core problem, getting finiky about anything, remind me of this instruction. I rather work on main objectives and keep the fluff, going down the rabbit hole, unable to pick between two solution when both are equally bad/good. Unecessary perfection is dangerous. There is almost always time to comeback and fix things, but more likely we wont have to comeback. Ensure you do it as politely as you can. And not annoy be by contineously pointing it out. Give me some breathing room, then you can remark again. I wont tolerate you interfering with this reminder everytime.
- Elm: when running dev server as background task, check its last output to figure out if there any compilation errors. no need to run elm make. Also if dev server is not running offer to start one.
- Fixing subtle duplications or unnecessary indirection may help uncover major duplications that were previously hidden - jumping to tackle major duplication upfront isn't always the right approach, analyze carefully.
- Always get approval before implementing; deviations from agreed plans require explicit discussion and permission.
- when presenting options/solutions always give recommendation
- When designing, avod margin, and prefer padding. especially for vertical alignment. Its ok to use margin auto for centering horizontally
- When designing, avod margin, and prefer padding. especially for vertical alignment. Its ok to use margin auto for centering horizontally
- For GitHub username/repo: use git remote; if not found, ask user
- For GitHub Pages: use native actions/deploy-pages + configure via gh CLI API