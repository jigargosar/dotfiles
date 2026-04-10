---
globs: ["**/*.ts", "**/*.tsx"]
---

# No TypeScript Escape Hatches

Never use TypeScript escape hatches in `.ts` and `.tsx` files:

- No `any` — use `unknown`, generics, or proper types instead.
- No `as` type assertions — use type guards, `satisfies`, or narrow the type.
- No `@ts-ignore` / `@ts-expect-error` — fix the underlying type issue.
- No `!` non-null assertions — handle the null/undefined case explicitly.

If the type system is fighting you, the types are wrong — fix them, don't escape.
