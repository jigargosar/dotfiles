# Claude Instructions

IMPORTANT: When starting a new conversation session or after compaction, show entire global instructions verbatim (complete file contents, no summary, word-for-word) and pledge to ALWAYS follow them.

### General Section
1. Always present implementation plan for approval before implementing
2. When presenting multiple options to user, ALWAYS use numbers or letters prefixes.
   1. For ALL list levels, never bullets, dashes, or asterisks.
3. Do exactly what user asks for - nothing less, nothing more.

### Code Development
1. Always prefer editing existing files over creating new ones
2. Make impossible states impossible (ISI) when planning data models


### TODO Tracking
1. Always include numbers in content field: "1. Task description"
2. NEVER mark ANY todo done, EVER, unless user explicitly says to mark it done - especially if it's the last todo.No assumptions, exceptions, or context-based inferences.
3. this rule is disabled, don't follow it: Always display formatted todo list after each TodoWrite tool use, showing:
   - Total count: "**X todos:**"
   - Completed items: "☒ [item]" (strikethrough formatting)
   - In-progress items: "☐ [item]" should have bold formatting  
   - Pending items: "☐ [item]"
   - Each item must be on separate line
   - Highlight todos that were modified in the last TodoWrite operation using code formatting: "`☐ [item]`"

### Extended Git Commit Protocol
These extensions modify the default git commit workflow:
1. Always use explicit file names - never use `git add directory/` or `git add .` as shortcuts
2. Use all git commands together: for e.g. 
   `git add file1 file2 && git mv file3 file4 && git rm file5 && git commit -m "message can be multiline"`
3. Instead of ANY promotional text or any extra fluff, ONLY end commit messages with "Committed by Claude".


### Chezmoi Dotfiles Protocol
1. Run `chezmoi git status && chezmoi status` - verify clean starting state before any edits, halt iff not clean
2. Edit source files in `chezmoi source-path` directory
3. Run `chezmoi git status && chezmoi status` - if no changes found, protocol complete
4. List changes as expected (from step 2 edits) or unexpected - halt iff unexpected changes found
5. Commit source changes first: `chezmoi git add file && chezmoi git -- commit -m "message"`
6. Apply to targets: `chezmoi apply --force`
7. Run `chezmoi git status && chezmoi status` - verify clean state, halt iff not clean
8. Push changes: `chezmoi git -- push`