---
name: structural-refactoring
description: Use when refactoring or restructuring existing code, or when about to propose extracting helpers, splitting files, introducing abstractions, or deduplicating similar code. Provides the toolbox of structural moves and the criteria for when each one is warranted. Counteracts the default reflex to over-structure at the file/class level and under-structure at the function level.
---

# Structural Refactoring

Refactoring is choosing which tool to reach for and when. The tools are ordered from cheapest to most expensive to reverse. Always prefer the cheapest tool that does the job, and only escalate when the current tool has proven insufficient across multiple features, not on first suspicion.

## The Toolbox (cheapest first)

**Tool 1 — Name a block with a nested or local function.** Cost: near zero. Reversible: trivially. Use when a block would read better with a name than without. Trigger is whether the name communicates intent the block doesn't. Not size. A one-line chain can deserve a name; a fifty-line function doing one coherent thing may not need splitting. Do not extract because something is "too long." Do not skip extraction because something is "too short."

**Tool 2 — Make dependencies explicit by passing them as arguments.** Cost: near zero. Use when a nested function reaches into its enclosing scope for values. Passing them as arguments reveals the function's real signature and shrinks its effective scope. Almost always the first move when a large function has accumulated helpers that share its locals. Do this before considering any larger restructuring — it often reveals the function's real role is simpler than it looked, and it is a prerequisite for the next tool.

**Tool 3 — Lift a function to module scope.** Cost: low. Use only after Tool 2 — once dependencies are explicit, the function no longer needs its enclosing scope and can move out. Side effect: the enclosing scope gets smaller and easier to read. Do not lift a function that still closes over locals; make the dependencies explicit first.

**Tool 4 — Group related functions into a closure-based mini module.** A function that returns an object of handlers with private state in the closure. Cost: moderate. Reversible: yes, by inlining back. Use when several module-level functions need to share state that does not belong to the rest of the file. Prefer this over creating a new file when the scoping need is real but the grouping is not yet proven stable.

**Tool 5 — Group by comment headers.** Cost: near zero. Use when a collection of module-level functions is growing and you suspect clusters but are not sure which ones belong together. A comment header is a discovery tool, not a commitment. If the grouping is wrong, you move a comment. If it stays stable across several features, it is evidence for the next tool.

**Tool 6 — Separate internal helpers into a sibling file by naming convention** (e.g. `Foo.ts` and `Foo.internal.ts`). Cost: low. Use when helpers have become noisy enough to obscure the main file's public behavior, but they are not yet a distinct concern. The exposed surface does not change.

**Tool 7 — Move to a new file.** Cost: high. Reversible: expensive. Use only when several functions have started to operate on the same data type, and that type plus its operations form a coherent unit with a small public surface. This is type cohesion, and it is the only justification for a new file that holds up. Do not create a file because the current file is "getting long." Length is not a cohesion signal. A four-thousand-line file with a small, well-chosen exported surface is healthy.

**Tool 8 — Inlining.** Cost: near zero. Reversible: yes. Inlining is not a failure mode, it is a diagnostic. After any extraction, ask whether the caller reads better now. If not, inline back. For a cluster of abstractions whose value is unclear, inline them all into one block and see what happens — either nothing new emerges and you restore, or a better shape becomes visible that the old boundaries were hiding. Use inlining routinely, not as a last resort. Willingness to inline is the test of whether an abstraction is earning its place.

## When to Apply Which Tool

Start with the cheapest tool that addresses what you observe.

- A block wants a name → Tool 1.
- A nested function reaches into its scope → Tool 2, then possibly Tool 3.
- Several functions share private state → Tool 4.
- You suspect clusters but are not sure → Tool 5 and wait.
- Helpers are obscuring the public behavior of a file → Tool 6.
- Type cohesion is demonstrable and stable across multiple features → Tool 7.

The ordering is load-bearing. Each step teaches whether the next is warranted. Skipping steps means committing without having learned.

## Defaults to Resist

**Do not split files by length.** Ask whether the exports still read like a clean table of contents. If yes, the file is fine regardless of line count.

**Do not deduplicate on first sight.** When two modules grow similar helpers, let the duplication live until you know whether the similarity is real or coincidental. If both copies evolve in lockstep across several features, extract. If one diverges, you were right not to couple them. Small duplication is information, not debt.

**Do not extract because a function is long. Do not skip extraction because a function is short.** Size is never the criterion in either direction. The criterion is whether a name helps.

**Do not introduce abstractions during feature work in anticipation of a shape.** Write the feature, make it work, then look at what emerged. Sometimes nothing emerges and no restructuring is needed. That is a valid and common outcome.

**Do not treat past abstractions as sacred.** The current shape of the code has more information than the memory of why the old shape was chosen. Inline freely to test.

**Do not jump to Tool 7 when Tools 1 through 4 have not been tried.** The reflex to create new files and new top-level abstractions is the most common over-structuring failure. Stay low in the toolbox until forced upward by evidence.
