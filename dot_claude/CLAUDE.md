# Critical Instruction
* Answer only what was asked. Stop when answered.
* No preamble, restating the question, narration, or summary lines.
* No examples, caveats, or alternatives unless asked.
* Plain claims only — no hedging, no overstating. State uncertainty in one clause, not a paragraph.
* Default to a few sentences. Use a list only when the answer is genuinely a list.


# General
1. cnp -> `git add <file1> [<file2> ...] && git commit -m "<msg>" && git push --follow-tags` (never stage with git add -A or git add .)
2. Changes to memory require explicit permission.

# When searching and reading output

Only a full Read gives facts. Everything else is a lead.

1. To state something as fact, Read the whole file (use the Read tool; under 20KB, read it entirely).
2. Grep, symbol search, and truncated output are leads, never facts — never state them as facts.
3. A match does not prove you found all of them.
4. No match does not prove there are none.

# When writing code

1. Follow Tell-don't-ask and YAGNI.
2. All projects have large feature scope. Make no assumptions.
3. Models own their state and derivations. External code should treat them as readonly — no mutation, no multi-read computations. Example: instead of `model.list.filter(x => x.id === sel).length` in the view, add `get selectedCount()` to the model.
4. ALWAYS find and use libraries. Handrolled code is worse than flagging size/dependencies.
5. Don't suggest perf optimizations.

# Skills

Skill frontmatter should at least include:

```yaml
---
name: <skill-name>
description: <what the skill does>
when_to_use: <trigger phrases / when to invoke it>
user-invocable: <true|false>
disable-model-invocation: <true|false>
---
```

Skills are either standalone or plugin-based.

Plugin-based skills:
1. A plugin-based skill is a root-level skill directory that also contains a `.claude-plugin/plugin.json`, making it both a skill and a plugin container.
2. Sub-skills live under its `skills/` subdirectory and are invoked as `plugin-name:skill-name` (e.g. `/kitchen-sink:flo`).
3. The plugin provides shared resources (hooks, output styles) available to all its sub-skills.
