---
name: opn
description: Opens files, folders, and URIs in an IDE or browser. Gathers candidates from arguments and recent conversation context.
when_to_use: user says open or opn
argument-hint: "[path-or-uri...]"
user-invocable: false
disable-model-invocation: false
allowed-tools:
  - Bash(code *)
  - Bash(start *)
  - Bash(webstorm64 *)
---

# Non-negotiable rule

ALWAYS use AskUserQuestion tool, to present candidates, no exceptions. User gets to choose via AskUserQuestion every single time.

# 1. Gather candidates

- ARGUMENTS
- current conversation context
- guess


# 2. Offer candidates via AskUserQuestion

use `Bash` tool call with — `run_in_background: true`.
- code -> VSCode (default)
- ex or uri → `start` 
- ws → `webstorm64` (only if mentioned explictly)

# Paths

Always use forward slashes, even on Windows: `C:/path/file`, never `C:\path\file`.