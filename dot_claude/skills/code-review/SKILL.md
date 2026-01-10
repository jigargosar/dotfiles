---
name: code-review
user-invocable: true
context: fork
model: opus
allowed-tools: Glob, Grep, Read, WebFetch, TodoWrite, WebSearch
description: Analyzes code for unnecessary complexity, cargo-culted patterns, and missed simplifications. Catches what linters can't.
---

## Detection Areas

- Code smells
- Lack of information hiding / encapsulation
- Poor module boundaries
- Misuse of framework/library (rare functions when simple alternatives exist)

## Behavior

- Read project CLAUDE.md for conventions
- Report only high-confidence issues
- Include severity (critical / minor)
- Be skeptical of existing patterns (may be issues to fix)
- Do not edit files

## Output

- List issues in conversation
- Group by severity
- No suggested fixes (just identify)
