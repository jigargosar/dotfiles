---
name: code-audit
description: >
  Review code quality against coding standards (ISI, TDA, SSOT, encapsulation,
  error handling, naming, API design) and find implementation bugs (null derefs,
  off-by-one, stale refs, resource leaks, race conditions). Spawns two parallel
  agents — one for standards, one for bugs — then consolidates and
  cross-checks. Use when user asks to review code, audit code quality, check
  for violations, or invokes /code-audit.
allowed-tools: Read, Grep, Glob, Task, Bash(git status:*), Bash(git log:*), Bash(git diff:*)
---

# Code Audit

## Step 1: Determine scope

Inspect git state and present numbered options with a recommendation:

```bash
git status
git log -1 --name-only
```

Examples:
- Dirty files exist → "1. Review N dirty files + deps (Recommended)"
- Recent commit → "2. Review last commit (N files) + deps"
- Both → show both options
- Always include → "N. Specify files manually"

Wait for user to pick a number.

## Step 2: Expand review surface

For each seed file, trace imports (what it imports) and importers (what imports
it) — 1 hop in each direction. Present the final file list to the user before
proceeding.

## Step 3: Spawn review agents

Launch two general-purpose agents in parallel via Task tool with
`model: "sonnet"`. Pass each agent the file list and path to its guide.

Both agent prompts must include this preamble:
> **READ-ONLY review. Do NOT edit, write, delete, or run any destructive
> commands. Only use Read, Grep, and Glob tools. Return your findings as text.**

**Standards agent prompt**:
> [preamble]
> Read `~/.claude/skills/code-audit/references/smell-detector.md`
> for your complete instructions. Review these files: [file list]

**Bugs agent prompt**:
> [preamble]
> Read `~/.claude/skills/code-audit/references/bug-detector.md`
> for your complete instructions. Review these files: [file list]

## Step 4: Cross-check (do NOT merge)

After both agents return, cross-check between the two result sets:
- Does a proposed bug fix introduce a standards violation?
- Does a proposed standards fix introduce a bug?
- Remove exact duplicates (same location + same problem) — keep the version
  from whichever agent is the better fit (standards issue → standards section,
  bug → bugs section)

**Keep findings in their original category.** Never move a standards finding
into the bugs section or vice versa.

## Step 5: Present report — two separate sections

Present all findings in **two clearly separated sections**. Never interleave.

### Section 1: Standards Violations

Number issues S1, S2, S3, … For each:
- Issue ID (S*n*), severity (High/Medium/Low), standards category
- What's wrong (describe the problem, not the fix)
- Location (file:line)
- Solution with self-critique flag (keep/discard/uncertain + reasoning)

### Section 2: Bugs

Number issues B1, B2, B3, … For each:
- Issue ID (B*n*), severity (High/Medium/Low), bug category
- What's wrong (describe the problem, not the fix)
- Location (file:line)
- Solution with self-critique flag (keep/discard/uncertain + reasoning)

### Summary table

End with an ASCII summary table with **separate rows for each section**:

```
+-----+===================+=======+==========+=========+
| #   | Section           | High  | Medium   | Low     |
+-----+===================+=======+==========+=========+
| 1   | Standards (S)     | …     | …        | …       |
+-----+-------------------+-------+----------+---------+
| 2   | Bugs (B)          | …     | …        | …       |
+-----+-------------------+-------+----------+---------+
| 3   | Total             | …     | …        | …       |
+-----+-------------------+-------+----------+---------+
```

Follow with: items flagged as uncertain or needing discussion.
