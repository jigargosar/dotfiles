---
name: git-init
description: Initialize a git repository with proper .gitignore and initial commit. Use when user asks to initialize git, set up git, or create a repo.
user-invocable: true
allowed-tools: Glob, Read, Write(.gitignore), AskUserQuestion, Bash(git init), Bash(git status -s), Bash(git add *), Bash(git commit -m "Initial commit"), Bash(gh api user --jq .login), Bash(gh repo create *), Bash(git push --follow-tags)
disable-model-invocation: true
---

# Git Init

Initialize a git repository with proper .gitignore and initial commit.

## Steps

### Init
1. Run `git init`

### Gitignore
2. Read `~/.claude/skills/git-init/gitignore-base.template`
3. Detect project type from existing files. Default to Node/pnpm if unclear. Add extra project-specific entries not already in the template.
4. Write `.gitignore`

### Review & Stage
5. Run `git status -s`. Show count of all pending files.
6. Flag any suspicious files (large binaries, secrets, credentials).
7. If suspicious or more than 50 files: pause and discuss with user.
8. Otherwise: list all files, ask user to confirm, and stage.

### Commit
9. Stage confirmed files and commit with message "Initial commit".

### Remote — Default Path
10. Infer GitHub username from context, otherwise run `gh api user --jq .login`.
    If gh fails, figure out why and present appropriate options to the user.
11. Defaults: public repo, named after current directory.
    Ask: "Create public GitHub repo '<username>/<directory-name>' and push?"
12. If accepted: `gh repo create <username>/<directory-name> --public --source=. && git push --follow-tags`. Done.
13. If user does not accept, proceed to step 14.

### Remote — Custom Path
14. AskUserQuestion — visibility:
    - question: "Create a GitHub remote repository?"
    - header: "Git remote"
    - options:
      - "Public (Recommended)" — You'll pick the repo name next
      - "Private" — You'll pick the repo name next
      - "Local only" — Skip remote, keep local git only
    If Local only: Done.

15. AskUserQuestion — repo name:
    - question: "Repository name?"
    - header: "Repo name"
    - options:
      - "Use current directory name (Recommended)"
      - other: user provides custom name

16. Create and push:
    - Public: `gh repo create <username>/<repo-name> --public --source=. && git push --follow-tags`
    - Private: `gh repo create <username>/<repo-name> --private --source=. && git push --follow-tags`
