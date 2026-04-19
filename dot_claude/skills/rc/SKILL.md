---
name: rc
description: Re-read CLAUDE.md and strictly apply its rules to the current response.
when_to_use: Trigger when user asks to re-read CLAUDE.md or system instructions and re-apply.
argument-hint: none
disable-model-invocation: false
user-invocable: true
allowed-tools: Read
---

1. Read `C:\Users\jigar\.claude\CLAUDE.md`.
2. Apply every rule strictly to the current response and all subsequent responses in this session.
3. For content not governed by CLAUDE.md, reply verbatim.
