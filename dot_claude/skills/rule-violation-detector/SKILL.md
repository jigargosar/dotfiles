---
name: rule-violation-detector
description: Use when user says "violation", "vio", "you violated", "broke rule", "didn't follow instruction", or similar indicating AI broke a rule from global instructions
---

# Rule Violation Detector

## Common Violations (check first)

1. **Bash paths**: Using `cd /path &&` prefix or absolute paths instead of relative paths
2. **Git add**: Using `-A` or `.` instead of explicit file names
3. **Verbose responses**: Being too wordy when user expects terse replies
4. **Acting without permission**: Making edits when user only asked a question
5. **Not presenting plan**: Implementing without approval
7. **Rabbit hole**: Not reminding user when they stray off path

## Instructions

1. Check common violations above first
2. If not obvious, read `~/.claude/CLAUDE.md` to find the exact rule violated
3. Identify the specific violation
4. Correct it
5. Re-do the last response properly