---
name: clean-code
description: Review source code and produce a refactoring prompt. Use when user wants to analyze code for real issues and generate an actionable fix prompt.
argument-hint: [file-or-glob]
disable-model-invocation: true
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(* | pbcopy*)
---

## Review this code and produce a refactoring prompt

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

### Output format

For each real issue:
1. What's wrong — name the function, name the problem
2. Why it matters — what breaks or what goes wrong on the next edit
3. Fix — exact changes with every affected call site. Not "consider refactoring." Show what to do.
4. Verify — one manual test that proves it works

Combine everything into a single prompt starting with "## Fix N issues in [filename]" that can be copy-pasted to another AI to execute. End with a combined verify section.

### Constraints on the output prompt
- Only include issues you're genuinely confident about
- Preserve all existing behavior — no visual, audio, or timing changes
- No new features, no file restructuring, no renaming IDs
- If you found nothing real, say so. An empty list is better than invented work.
- After generating the prompt, copy it to the clipboard so the user can paste it directly into another AI.
