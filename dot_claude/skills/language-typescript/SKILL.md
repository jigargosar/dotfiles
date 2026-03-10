---
name: language-typescript
description: TypeScript type safety guardrails. TRIGGER when project contains tsconfig.json.
user-invocable: false
disable-model-invocation: false
---

# Trust the compiler — it is the single source of truth. Don't lie to it, don't second-guess it.

## Don't lie to the compiler
- No hacks, no `as`, no `!`, etc.
- No `any` — use `unknown` and narrow
- No `enum` — use `as const` objects or union types
- No `{}`, `object`, or `Function` as types — use precise shapes and signatures
- `satisfies` over `as` when validation is needed

## Don't second-guess the compiler
- No optional chaining (`?.`) when type says non-nullable — fix the type instead
- No redundant null/undefined checks when type already guarantees presence
- No defensive `?? fallback` or `|| default` on non-optional types
- No runtime `typeof` guards when the type is already known — fix the type upstream
- No index signatures when the shape is known — spell out the properties

## Declarations
- Always use `const`. Usage of `let` requires strong justification.
- `Readonly` / `readonly` by default — mutability requires justification (like `let`)
- Use `switch` with `assertNever` for type discrimination, never `if/else` chains
