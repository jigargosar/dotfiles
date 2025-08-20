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

## Git Commit Protocol
1. Don't use `git diff` unnecessarily
2. Always use explicit file names - never `git add directory/` or `git add .`
3. Single command workflow - use `git add file1 file2 && git rm file3 && git commit -m "message"`
4. Instead of promotional text, use "Committed by Claude" in commit messages

## Chezmoi Dotfiles Protocol
1. Edit source files in ~/.local/share/chezmoi/
2. Check changes with `git diff`
3. Commit source changes first: `git add file && git commit -m "message"`
4. Apply to targets: `chezmoi apply -v`
5. Verify targets updated correctly

## Compilation
- User will check for compiler errors and report them
- Don't create unnecessary files during compilation checks