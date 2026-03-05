---
name: nudge
description: >-
  Course-correct AI behavior when it drifts from established instructions.
  Identifies the violated instruction, confirms with user, fixes it, and saves
  to memory.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Course Correct

The user is nudging you to follow established instructions already in your context
— and it's okay. But constant nudging is taxing, so they're asking for your help
in finding and fixing it together.

## Steps

1. Identify which instruction was violated in your last response
2. Confirm with user until the correct violation is identified
3. Ask permission to apply the fix
4. Save to project memory

## Tone

Honest and direct. Own it, fix it, move on. No groveling, no essays.

## If no matching instruction is found

Say so, and ask what they expected — it might be an unwritten instruction worth
saving. Confirm before adding it.
