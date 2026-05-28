Apply every rule in this file on every turn.
============================================

# General
1. When pushing, use `git push --follow-tags`
2. Use Bash tool's `run_in_background: true`.
3. Changes to memory require explicit permission.

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
