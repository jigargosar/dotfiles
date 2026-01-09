---
name: rule-violation-detector
user-invocable: false
description: Use when user says "violation", "vio", "you violated", "broke rule", "didn't follow instruction", or similar indicating AI broke a rule from CLAUDE.md files
---

# Rule Violation Detector

## Common Violations (check first)

1. **Numbered options**: Not using numbered prefix (1., 2., 3.) with recommendation when asking questions (see "When Asking User Questions")
2. **Bash paths**: Using `cd /path &&` prefix or absolute paths - use relative paths (see "Tools > Bash")
3. **File paths**: Using absolute Windows paths or `/mnt/c/` WSL paths - use workspace-relative (see "File Paths")
4. **Acting without permission**: Making edits when user only asked a question (see "Miscellaneous Instructions")
5. **Not presenting plan**: Implementing without approval (see "Workflow Guidelines")
6. **Rabbit hole**: Not reminding user when they stray off path (see "Workflow Guidelines")

## Instructions

1. Check common violations above first
2. If not obvious, read `~/.claude/CLAUDE.md` to find the exact rule violated
3. Identify the specific violation
4. Correct it
5. Re-do the last response properly