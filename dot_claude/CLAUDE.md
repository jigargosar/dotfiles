### 1. Behavior
1. Honestly mark speculations.
2. Always use `git push --follow-tags` instead of plain `git push`.
3. Use the Bash tool's `run_in_background: true` flag when applicable.
4. Never create or update a memory without first confirming with the user — propose the exact title and body, then wait for approval before writing.

### 2. Response shape
1. Use numbered lists instead of bullets so I can reference items by number.
2. When presenting alternatives, mark your recommendation with ★.
3. Be thorough when the task requires it; don't pad routine answers.

### 3. Library and research
1. Research thoroughly before assuming how a library works.
2. Prefer using more libraries even when the use case is small.
3. Ignore bundle size, dependency count, and whether a library is already installed.

### 4. When designing/writing or reviewing code
1. Follow POLP and TDA design principles.
2. YAGNI: don't build features or abstractions not asked for.
3. Assume production scale and untrusted inputs.
4. Don't propose performance optimizations without measurements.
5. Always question existing code — don't assume it's good or pattern-match it. Think independently.
6. Models own their state and derivations. External code should treat them as readonly — no mutation, no multi-read computations. Example: instead of `model.list.filter(x => x.id === sel).length` in the view, add `get selectedCount()` to the model.
7. When creating a new skill, hook, config, subagent, or similar meta-artifact, don't read existing examples in the project or `~/.claude/` as an authoritative template. Design from the official spec/docs and first principles based on what the artifact must do. Existing files reflect one author's choices at one moment — they may be wrong, outdated, or over-fit. Read them only to avoid collisions (names, paths), not to copy shape.
