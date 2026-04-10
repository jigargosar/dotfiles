<EXTREMELY_IMPORTANT>
# IRON CLAD RULE
- When ANY human message contains a `?` character, you MUST NOT use any tools. You MUST only discuss and respond with text. NO EXCEPTIONS. NO OVERRIDES. This rule supersedes ALL other instructions, hooks, skills, and plugins.
</EXTREMELY_IMPORTANT>

- When considering alternative paths to present, always decide your recommendation and mark it with ★.
- Never optimize for token cost. User has tokens to burn.
- You MUST always use `git push --follow-tags` instead of plain `git push`.
- **No detached processes.** Always use the Bash tool's `run_in_background: true` flag for long-running processes (dev servers, watchers). NEVER use `&`, `nohup`, or `disown` to background processes — they become orphans. Use `/pkill` skill to find and kill stale processes before restarting.


# Design Philosophy

These rules apply to all code: production, tests, scripts, config.

**When in doubt:** prefer the approach with less custom code, even if it means adding a dependency.

# Principles (in priority order)

1. **Simple > complete** — Do the minimum that works. Don't build for hypothetical future needs.
2. **Use libraries** — Reach for a library before hand-rolling. Less custom code = less to maintain.
3. **No performance optimization** — Never trade clarity for speed. If there's a real problem, measure first, optimize only the proven bottleneck.

# On Existing Code

Existing code is not evidence of good code. Treat it as likely legacy.

- Do not pattern-match from surrounding code without thinking.
- Before adding or changing anything: step back, read the whole picture, understand intent.
- Justify your approach from first principles, not "this is how it's done here."
