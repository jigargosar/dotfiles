---
name: code-smell-audit
description: Review source code for readability and simplification opportunities. Surfaces findings for another AI session to independently evaluate and apply.
argument-hint: [file-or-glob]
disable-model-invocation: true
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(clip:*, pbcopy:*, xclip:*)
---

## Review this code for things that make it harder to reason about

Read all source files matching `$ARGUMENTS` completely. If no argument given, read source files under `src/` (or the main source directory). Skip config files, lock files, and build output.

For each function, ask these questions:

### Can I understand this function without looking elsewhere?
- If it reads or writes state that its name doesn't mention, the name is lying or the state is in the wrong place
- If it has a side effect that callers don't expect from the name, the side effect should move to the callers or the name should change

### Is this code where it belongs?
- If the same logic exists in two places, one should be a function call
- If a helper is far from its only caller, move it closer
- If a constant duplicates another constant, delete one
- If a function defines something inline that has a name elsewhere, use the name

### Does this function do exactly what its name says?
- A display function that mutates game state is lying — move the mutation to the caller
- An "add" function that triggers a chain of unrelated work is two functions stapled together
- A function named after a visual operation that also controls logic state is doing two jobs

### Is every line earning its place?
- If a variable is identical to an existing constant, use the constant
- If a wrapper function just calls another function with the same arguments, delete it
- If a line is redundant because the next line does the same thing, delete it

### What NOT to flag
- Don't rename things for style consistency
- Don't flag short variable names in small scopes
- Don't split things that callers always use together
- Don't flag anything that requires a behavior change to fix — this is about the same logic, written more clearly

### Output

DO NOT write fixes. DO NOT show code blocks. Only output findings as one-liners. Err on the side of including too many — 10-15 candidates is normal for a 300-line file. The skeptic will filter; your job is to not miss anything.

Copy the following template to the clipboard, filled in with your findings:

    Read [filenames]. A code smell audit flagged these simplification candidates:
    1. functionName() — one sentence: what's unclear and how it should be simpler
    2. functionName() — one sentence: what's unclear and how it should be simpler
    ...
    You are a skeptic, not an executor. For each finding:
    - Read the code yourself and form your own opinion
    - If simplifying it would make the code longer or harder to follow, reject it
    - If the "smell" is actually intentional coupling that callers rely on, reject it
    - If the change would alter any behavior, timing, or visual output, reject it
    - If the simplified version isn't obviously better at a glance — if you have to explain why it's better — reject it
    - If the change just moves code around without reducing total lines or concepts, reject it
    - If a function's name lies about what it does — it has side effects the name doesn't mention — fixing that is a win even if line count stays the same
    - A side effect being *logical* doesn't mean the name isn't lying. The test: if a new developer reads only the function name and its call sites — not the body — would they know about the side effect? If no, the name lies
    - Don't inline a named wrapper if the name is shorter or clearer than the raw expression — removing a readable name is a downgrade
    - Only apply changes that make the code shorter, clearer, or easier to reason about locally
    For the ones that survive: show exact code changes, list every affected call site, provide a manual verify step.
    The code must behave identically before and after. No new features. Extract to eliminate duplication, not to add architecture.

The skill's job is to surface candidates. The receiving session's job is to challenge them. A simplification must make the code obviously clearer to survive.
