# Project Standards

## Code Development
- Take baby steps with testing at each stage for complex changes
- Always prefer editing existing files over creating new ones
- Never create documentation files unless explicitly requested
- Follow existing code conventions and patterns
- Always present implementation plan for approval before implementing
- Make impossible states impossible (ISI) in data models

## TODO Tracking
- Use TodoWrite tool frequently for complex multistep tasks
- Track ALL work upfront when breaking down tasks, even for one-shot implementations
- Keep TODO state in sync with code state (for easy revert)
- Mark tasks complete immediately after finishing, don't batch
- Only have ONE task in_progress at a time

## Git Commits
- Commit with explicit file names, avoid blind `git add .`
- Use single command for commit (don't stage separately)
- Use descriptive commit messages
- Include "Committed by Claude" instead of promotional text

## Compilation
- User will check for compiler errors and report them
- Don't create unnecessary files during compilation checks