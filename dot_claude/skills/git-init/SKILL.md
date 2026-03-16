---
name: git-init
description: Initialize a git repository with proper .gitignore and initial commit. Use when user asks to initialize git, set up git, or create a repo.
user-invocable: true
allowed-tools: Glob, Read, Write(.gitignore), Bash(git init), Bash(git status -s), Bash(git add *), Bash(git commit -m "Initial commit"), Bash(gh api user --jq .login), Bash(gh repo create *), Bash(git push --follow-tags)
disable-model-invocation: true
---

# Git Init

Initialize a git repository with proper .gitignore and initial commit.

## Steps

### Phase 1 — Scaffold
1. Run `git init`

### Phase 2 — Local
2. Read `~/.claude/skills/git-init/gitignore-base.template` as the base
3. Detect project type from existing files. If unclear, default to Node/pnpm. Add any extra project-specific entries not already in the template.
4. Write `.gitignore` with combined content
5. Run `git status -s`.
   a. Show the count of all pending files.
   b. Flag any suspicious files (large binaries, secrets, credentials).
   c. If suspicious files or more than 50 files, pause and discuss with user.
   d. Otherwise, list all files and ask user to confirm staging.
6. Stage confirmed files and commit with message "Initial commit".

### Phase 3 — Remote
7. Infer GitHub username from context, otherwise run `gh api user --jq .login`.
   Defaults: public repo, named after current directory.
   Ask: "Create public GitHub repo '<username>/<directory-name>' and push?"
   a. If user accepts:
      `gh repo create <username>/<directory-name> --public --source=. && git push --follow-tags`
      Done.
   b. If user declines, use AskUserQuestion to ask about GitHub remote:
      - question: "Create a GitHub remote repository?"
      - header: "Git remote"
      - options:
        - label: "Public (Recommended)", description: "You'll pick the repo name next"
        - label: "Private", description: "You'll pick the repo name next"
        - label: "Local only", description: "Skip remote, keep local git only"
   c. If user chose remote, use AskUserQuestion to ask for repo name:
      - question: "Repository name?"
      - header: "Repo name"
      - options:
        - label: "Use current directory name (Recommended)", description: ""
        - label other: user provides custom name
8. If public:
   `gh repo create <username>/<repo-name> --public --source=. && git push --follow-tags`
   If private:
   `gh repo create <username>/<repo-name> --private --source=. && git push --follow-tags`
