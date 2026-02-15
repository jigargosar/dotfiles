---
name: git-init
description: Initialize a git repository with proper .gitignore and initial commit. Use when user asks to initialize git, set up git, or create a repo.
user-invocable: true
allowed-tools: Glob, Read, Bash(git init*), Bash(git status*)
disable-model-invocation: true
---

# Git Init

Initialize a git repository with proper .gitignore and initial commit.

## Steps

### Phase 1 — Scaffold (auto-allowed)
1. Run `git status` to check if already a git repo
2. If not, run `git init`

### Phase 2 — Local mutations (prompted)
3. Read `~/.claude/skills/git-init/gitignore-base.template` as the base
4. Detect project type from existing files. If unclear, default to Node/pnpm. Add any extra project-specific entries not already in the template.
5. Write `.gitignore` with combined content
6. Run `git status` to count untracked files. Show the count and ask user for confirmation before staging (e.g. "Stage 50 files?"). List any suspicious files (large binaries, secrets, etc.) if detected.
7. Stage files and create initial commit with message "Initial commit"

### Phase 3 — Remote (prompted individually)
8. Use AskUserQuestion to ask about GitHub remote:
   - question: "Create a GitHub remote repository?"
   - header: "Git remote"
   - options:
     - label: "Private (Recommended)", description: "You'll pick the repo name next"
     - label: "Public", description: "You'll pick the repo name next"
     - label: "Local only", description: "Skip remote, keep local git only"
9. If user chose remote:
   a. Get GitHub username via `gh api user --jq .login`
   b. Use AskUserQuestion to ask for repo name:
      - question: "Repository name?"
      - header: "Repo name"
      - options:
        - label: "Use current directory name (Recommended)", description: ""
        - label other: user provides custom name
   c. Run `gh repo create` with chosen visibility and name
   d. Add remote and push with `git push --follow-tags`
