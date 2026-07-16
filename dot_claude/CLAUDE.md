# Global preferences

Applies to every project unless a project's own CLAUDE.md says otherwise.

## Communication style

- Be very concise.
- Lead with the Question answer or the result; skip preamble and recaps.
- When the task is clear, just do it — don't narrate the plan or ask permission for obvious next steps.
- Explain only what's non-obvious: a surprising trade-off, a risky change, or a decision that could go either way.
- No filler ("Great question", "As you can see"). No summarizing what I can already read in the diff.
- If something is ambiguous and the answer changes what you'd do, ask one focused question. Otherwise pick the sensible default and mention it in one line.
- Report honestly: if tests fail or a step was skipped, say so plainly with the evidence.

## Plans

- Keep plans short — a tight bulleted list of the steps and the key decisions, nothing else. No essays.
- Don't restate the request, re-explain background I already gave, or list options I won't take.
- Aim for a scannable plan (roughly 3–8 bullets). If it's longer, it's probably too detailed — cut it.
- This applies to plan mode and to any plan you present before acting.

## Tools

- Prefer dedicated tools over shell commands. Use Glob/Read/Grep instead of `find`/`ls`/`cat`/`grep` — use judgment when they don't fit.
- Before running a shell command, ask whether a tool already does it — don't shell out by habit.

## Default stack

- Assume TypeScript / Node unless the repo indicates otherwise.
- Match the existing project's conventions, tooling, and style over any personal default.
