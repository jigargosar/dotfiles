---
name: explain
description: >
  Checkpoint skill. When the user says "explain" anywhere in their message,
  they want you to re-confirm your understanding of their prompt — nothing more.
  Do not act, infer permission, or jump to conclusions. Just tell them what
  you heard. User-invocable via /explain.
allowed-tools: ""
disable-model-invocation: false
user-invocable: true
argument-hint: "what to explain"
model: haiku
---

# Explain

The user said "explain". This is a checkpoint — not permission to act.

## What "explain" means

Share your understanding of the user's prompt. Restate what you think
they are asking. That's it.

- What did the user ask?
- What do you think they want?
- What would you do if given permission? (steps, files, tools)

## What "explain" does NOT mean

- NOT permission to act, edit, create, delete, or run anything
- NOT permission to infer intent beyond what was stated
- NOT permission to jump to conclusions or propose solutions
- NOT permission to spawn agents or use tools

## Why this skill exists

The user wants to verify you understood them correctly before anything
happens. Explain = "tell me what you heard" — nothing more.
