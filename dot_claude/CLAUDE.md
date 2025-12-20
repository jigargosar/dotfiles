# Claude Instructions Summary

## Communication Style

- Always Use numbered prefixes (1., 2., 3.) for all lists, never bullet points (-).
- When presenting options or asking user to choose, always provide recommendation.

- Example (wrong - uses bullets):

```md
Analysis of options:

- First approach
- Second approach
- Third approach

Recommendation: Option 2
```

- Example (correct - uses numbered prefixes):

```md
Analysis of options:

1. First approach
2. Second approach
3. Third approach

Recommendation: Option 2
```

## Workflow Guidelines

- Always present implementation plan for approval before implementing
- Only do what's explicitly asked, nothing more/less - discuss additional work first
- Don't keep jumping to implementation without thinking through the design first
- If 2-3 solutions rejected, ask user to share their approach:
    > "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of? That would be more efficient than me continuing to guess."
- Be concise but complete, not super verbose
- Don't present silly/obviously wrong answers
- When asked to "add todo:" just add it, no discussion needed - focus on current discussion
- if my request is incorrect, can't be fulfilled don't proceed ahead without explicit confirmation
- Always get approval before implementing; deviations from agreed plans require explicit discussion and permission
- If I am straying off path, not focusing on core problem, getting finicky about anything, remind me of this instruction. I rather work on main objectives and keep the fluff, going down the rabbit hole, unable to pick between two solution when both are equally bad/good. Unnecessary perfection is dangerous. There is almost always time to come back and fix things, but more likely we won't have to come back. Ensure you do it as politely as you can. And not annoy be by continuously pointing it out. Give me some breathing room, then you can remark again. I won't tolerate you interfering with this reminder everytime.

## General Instructions

- Workflow: Always prefer editing existing files over creating new ones
- Code Quality: Make impossible states impossible (ISI) for data models
- Code Quality: Default design must always focus on Single Source of Truth
- Code Quality: Focus on readability over performance (warn only about exponential increases)
- Code Quality: Want simpler solutions across functions, not blind single-function improvements
- Code Quality: By symmetry: keep child elements similar level of abstraction, prefer extraction of methods
- Code Quality: Don't worry about memory-heavy for large states unless exponentially costly - simplicity wins by default
- Code Quality: Don't add obvious comments where identifier name is clear
- Code Quality: Always prefer type aliases even for basic types (e.g., `Set(RowIdx, ColIdx)` not `Set(Int, Int)`)
- Code Quality: Never suggest internal implementation details to callers (Set.empty, Dict.empty, raw tuples, etc.)
- Code Quality: When a module uses type alias for its model, clients must treat it as opaque - type aliases are implementation choice, encapsulation is design principle
- Code Quality: Abstractions and precomputed configs are for decoupling/encapsulation, not optimization
- Error Handling: Never swallow/rethrow same exceptions - let them propagate to top level to fail fast
- Error Handling: **Exception:** Handle the case properly if needed for logical flow
- File Paths: Don't use cd command or absolute paths when files are relative to workspace
- File Paths: Use file names relative to current project workspace
- File Paths: ALWAYS use workspace-relative paths for project files - NEVER use absolute Windows paths or `/mnt/c/` WSL paths.
- File Paths: For simple renaming, use grep/sed etc., don't waste tokens unless refactoring is tricky
- File Paths: Ignore reference directory unless explicitly asked to look into it
- Tools: Don't run interactive commands - present a clear plan for user to run instead, don't skip steps you can't do
- Tools: Default to pnpm (infer from lockfile), not npm
- Tools: For "diff" requests, use git diff for entire repository, don't assume which files are modified - analyze for bugs and issues
- Package Management: if and when manually creating package.json file, ensure all dependencies are installed via package manager, don't hardcode them.
- Focus: Fixing subtle duplications or unnecessary indirection may help uncover major duplications that were previously hidden - jumping to tackle major duplication upfront isn't always the right approach, analyze carefully.
- Design: When designing, avoid margin, and prefer padding. especially for vertical alignment. It's ok to use margin auto for centering horizontally

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

## Package Publishing

- When user asks to publish: discuss and recommend semver level (patch/minor/major)
- Never assume what semver to use, always double check
- Run `npm version [level] && git push --tags`
- NEVER run `npm publish`, unless explicitly asked

## Elm

- Always check compilation with exactly this command `elm make <file> --output=NUL`. Don't invent your own.
- Never use `--output=elm.js` or similar - we only want to verify compilation, not create artifacts
- In Elm, when needed, try using multiple class attributes, to group semantic classes together, so it's easy to read and also not having to read a long list of classes.
- Elm: when running dev server as background task, check its last output to figure out if there is any compilation errors. no need to run elm make. Also, if dev server is not running offer to start one.

## Miscellaneous Instructions
- in typescript projects after a major change, always run lint and build
- in typescript projects after a major change, always run lint and build and also tests
- only after a major change in code you shuld run lint build and test
- you replies get too verbose, keep them brief and to the point. unless specifically asked
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
- no obvously wrong options/solutions shouldnt be listed. 