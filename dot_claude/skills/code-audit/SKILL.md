---
name: code-audit
description: Review source code and identify potential issues. Produces a findings list for another AI session to independently evaluate and fix.
argument-hint: [file-or-glob]
disable-model-invocation: true
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash(clip:*, pbcopy:*, xclip:*)
---

## Review this code and surface potential issues

Read all source files matching `$ARGUMENTS` completely. If no argument given, read source files under `src/` (or the main source directory). Skip config files, lock files, and build output.

Surface anything that looks like it could bite someone — bugs, dirty state, misleading names, hidden side effects, fragile patterns. When in doubt, include it. The receiving session will decide what's real.

### Output

DO NOT write fixes. DO NOT show code blocks. Only output findings as one-liners.

Copy the following template to the clipboard, filled in with your findings:

    Read [filenames]. A code review flagged these potential issues:
    1. functionName() — one sentence: what's wrong and why it matters
    2. functionName() — one sentence: what's wrong and why it matters
    ...
    You are a skeptic, not an executor. For each finding:
    - Read the code yourself and form your own opinion
    - If a finding is about a missing feature or unimplemented behavior, reject it — that's a product decision
    - If two things are coupled because callers always need both together, that's not a smell — reject it
    - If the issue is "currently harmless" with no concrete scenario where it breaks, reject it
    - Only implement fixes for issues where you can demonstrate a real failure or a clear trap for the next edit
    For the ones that survive: show exact code changes, list every affected call site, provide a manual verify step.
    Preserve all existing behavior — no visual, audio, or timing changes. No new features, no file restructuring, no renaming IDs.

The skill's job is to surface candidates. The receiving session's job is to challenge them. An issue must survive both to get fixed.
