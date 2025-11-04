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
- Check for CI/CD automation and ask if they want to run `npm publish`

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
- Always check compilation with `elm make <file> --output=NUL`
- Never use `--output=elm.js` or similar - we only want to verify compilation, not create artifacts


## Miscellaneous Instructions
- if and when manually creating package.json file, ensure all dependencies are installed via package manager, dont hardcode them.
- if my request is incorrect, can't be fulfilled don't proceed ahead without explicit confirmation.
- When pushing git commits to remote repository, ALWAYS use `git push --follow-tags` - NEVER use `git push` alone