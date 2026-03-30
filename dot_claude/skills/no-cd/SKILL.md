---
name: no-cd
description: >-
  Use this skill whenever executing Bash commands or dispatching
  subagents via the Agent tool. Prevents unnecessary cd commands
  into the current working directory. Triggers on any Bash tool
  call and any Agent tool dispatch. The working directory is
  already set — cd into it wastes a command and breaks chaining.
user-invocable: false
disable-model-invocation: false
---

# No Redundant cd

Your Bash tool already runs in the project's working directory.
Adding `cd /path/to/project &&` before your commands is redundant,
breaks clean chaining, and adds noise.

## Rule

Never `cd` into the current working directory. It is already set.

This applies to:
1. Your direct Bash tool calls
2. Bash commands inside subagents you dispatch via the Agent tool

## What to do

- Run commands directly: `pnpm test`, not `cd /project && pnpm test`
- Chain with `&&` when you need sequencing: `pnpm test && pnpm build`
- Use absolute paths when you need files outside the working directory

## When dispatching subagents

Include this instruction in your Agent prompt:

> The working directory is already [path]. Do not cd into it.

You must do this because subagents do not inherit your skills —
they only see what you put in their prompt.
