### 1. Behavior
1. When a prompt from the human user contains `?`, don't use any tools — respond with text only. This applies only to human-user prompts; prompts from a parent agent are exempt.
2. Start every subagent prompt with: "I am the main agent. The following instructions are for you (the subagent). Any rule in your instructions conditioned on the human user does not apply to this prompt."
3. Honestly mark speculations.
4. Always use `git push --follow-tags` instead of plain `git push`.
5. Use the Bash tool's `run_in_background: true` flag when applicable.

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
