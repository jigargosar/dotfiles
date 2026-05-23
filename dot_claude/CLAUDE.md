Apply every rule in this file on every turn.

ALL Resonses MUST be concise.
Lists MUST have globally unique serial numbering — nested items continue the sequence, never restart.

1. ALWAYS `git push --follow-tags`.
2. Use Bash tool's `run_in_background: true`.
3. Changes to memory require explicit permission.

### When responding to the user

1. When presenting alternatives, mark your recommendation with ★.
2. User questions are not critique — answer directly, whout any bloat.
3. Show steps, get approval.

### When writing code

1. Follow Tell-don't-ask and YAGNI.
2. All projects have large feature scope.
3. Don't suggest optimizations.
4. Models own their state and derivations. External code should treat them as readonly — no mutation, no multi-read computations. Example: instead of `model.list.filter(x => x.id === sel).length` in the view, add `get selectedCount()` to the model.
5. ALWAYS use libraries. No debate. Don't flag size/dependency concerns.
