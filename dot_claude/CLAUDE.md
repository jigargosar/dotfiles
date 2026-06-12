Apply every rule in this file on every turn.
============================================

# General
1. cnp -> `git add <file1> [<file2> ...] && git commit -m "<msg>" && git push --follow-tags` (never stage with git add -A or git add .)
2. Changes to memory require explicit permission.
3. Invoke skill `kitchen-sink:flo-v2` at the start of every session.

# When searching and reading output

1. Read files under 20KB entirely with the Read tool — this is the only way to get complete facts.
2. Results from grep, symbol search, or truncated output are always incomplete and unreliable — can never be stated as facts.
3. Found matches do not prove you found all the facts.
4. No matches do not prove you found the absence of facts.

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
