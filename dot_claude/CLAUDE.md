# Claude Instructions

IMPORTANT: When starting a new conversation session or after compaction, show entire global instructions verbatim (complete file contents, no summary, word-for-word) and pledge to ALWAYS follow them.

### Code Development
1. Always prefer editing existing files over creating new ones
2. Always present implementation plan for approval before implementing
3. Make impossible states impossible (ISI) in data models
4. When listing multiple options, ALWAYS use numbers or letters prefixes


### TODO Tracking
1. Always include numbers in content field: "1. Task description"
2. Never mark todo done, unless its tested and approved by user.
3. Always display formatted todo list after each TodoWrite tool use, showing:
   - Total count: "**X todos:**"
   - Completed items: "☒ [item]" (strikethrough formatting)
   - In-progress items: "☐ **[item]**" (bold formatting)  
   - Pending items: "☐ [item]"
   - Each item on separate line for readability
   - Highlight todos that were modified in the last TodoWrite operation using code formatting: "`☐ [item]`"
4. Never mark the last remaining todo as completed - always keep at least one todo visible for progress tracking and to prevent entire list disappearance


### Extended Git Commit Protocol
These extensions enhance the default git commit workflow:
1. Don't use `git diff` unnecessarily when changes are obvious
2. Always use explicit file names - never use `git add directory/` or `git add .` as shortcuts
3. Use all git commands together: for e.g. 
   `git add file1 file2 && git mv file3 file4 && git rm file5 && git commit -m "message can be multiline"`
4. Instead of ANY promotional text, use only "Committed by Claude" in commit messages.


### Chezmoi Dotfiles Protocol
1. Run `chezmoi git status && chezmoi status` - verify clean starting state before any edits, halt iff not clean
2. Edit source files in `chezmoi source-path` directory
3. Run `chezmoi git status && chezmoi status` - if no changes found, protocol complete
4. List changes as expected (from step 2 edits) or unexpected - halt iff unexpected changes found
5. Commit source changes first: `chezmoi git add file && chezmoi git -- commit -m "message"`
6. Apply to targets: `chezmoi apply --force`
7. Run `chezmoi git status && chezmoi status` - verify clean state, halt iff not clean
8. Push changes: `chezmoi git -- push`