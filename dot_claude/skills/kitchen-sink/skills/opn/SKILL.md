---
name: opn
description: Opens files, folders, and URIs in an IDE or browser. Gathers candidates from arguments and recent conversation context.
when_to_use: user says open or opn
argument-hint: "[path-or-uri...]"
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash(code *)
  - Bash(start *)
model: haiku
---

## Non-negotiable rule

NEVER open anything without an AskUserQuestion (AUQ) confirmation — no exceptions. User should always get to see the command you are about to execute.

# 1. Gather candidates

- ARGUMENTS
- current conversation context
- guess

# 2. Confirm src and destination 

- AUQ

# 3. Open

use `Bash` tool call with — `run_in_background: true`,
- VSCode → `code`
- URI → `start`

# Paths

Always use forward slashes, even on Windows: `C:/path/file`, never `C:\path\file`.