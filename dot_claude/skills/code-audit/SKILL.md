---
name: code-audit
description: Review source code and identify real issues. Use when user wants to analyze code for problems and generate a findings list for another AI to fix.
argument-hint: [file-or-glob]
disable-model-invocation: true
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(clip:*, pbcopy:*, xclip:*)
---

## Review this code and identify real issues

Read all source files matching `$ARGUMENTS` completely. If no argument given, read all source files in the project (respect .gitignore). Then find issues worth fixing.

### What "worth fixing" means

The bar is: would this bite someone? Not "could be nicer" — actually cause a bug, confuse the next edit, or silently do something its name doesn't say.

Common things AIs flag that usually aren't real problems:
- Single-letter variables in small scopes (fine)
- Missing abstractions in files under 500 lines (premature)
- "Separation of concerns" when the things are genuinely coupled (a function that lights a pad AND plays its sound is one concern, not two)
- Splitting a function that does two things when callers always need both together — that's coupling by design, not a smell
- Style inconsistencies that don't affect correctness

Common things AIs miss that usually are real problems:
- Async flows where an interruption leaves state dirty (flags stuck, UI elements stuck, cleanup skipped)
- Functions that secretly mutate state their name doesn't advertise — a render function updating a score variable, an "add" function triggering a chain of side effects
- Two functions stapled together where callers might need them separately
- Logic living in the wrong function — sound definitions inside game flow, domain rules inside UI helpers
- Multiple data structures encoding the same mapping that must stay in sync

You won't find all of these. You might find none. You might find something not on this list. Look at what's actually in the code, not what this prompt primes you to look for.

### Output

DO NOT write fixes. DO NOT show code blocks. Only output a findings list.

Copy the following to the clipboard — a short prompt that another AI session will execute:
```
Read [filenames] and fix these issues:
1. functionName() — one sentence describing what's wrong and why it matters
2. functionName() — one sentence describing what's wrong and why it matters
...
For each: show exact code changes, list every affected call site, provide a manual verify step.
Preserve all existing behavior — no visual, audio, or timing changes. No new features, no file restructuring, no renaming IDs.
```

Each finding must be one line: function name + problem + why it matters. No elaboration, no code, no fix suggestions.

### Constraints
- Only include issues you're genuinely confident about
- If you can name the function, name the problem, and show a concrete scenario where it causes confusion or breaks on the next edit — include it. Don't downgrade real findings to "fragile but currently masked" and then drop them.
- If you found nothing real, say so. An empty list is better than invented work.
