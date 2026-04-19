---
globs: ["**/*.ts", "**/*.tsx"]
---

# TypeScript rules

## 1. No escape hatches

Never use TypeScript escape hatches in `.ts` and `.tsx` files:

1. No `any` — use `unknown`, generics, or proper types instead.
2. No `as` type assertions — use type guards, `satisfies`, or narrow the type.
3. No `@ts-ignore` / `@ts-expect-error` — fix the underlying type issue.
4. No `!` non-null assertions — handle the null/undefined case explicitly.

If the type system is fighting you, the types are wrong — fix them, don't escape.

## 2. Discriminated unions: `tag` + switch + assertNever

1. Name the discriminant field `tag` — not `kind`, not `type`.
2. Dispatch on `.tag` with `switch`; put `assertNever(x)` in the `default` branch.
3. Following 1 and 2 makes exhaustiveness compile-checked: adding a variant becomes a compile error at every switch site.

```ts
function assertNever(_: never): never {
    throw new Error('unreachable')
}

switch (item.tag) {
    case 'path': return renderPath(item)
    case 'text': return renderText(item)
    default: return assertNever(item)
}
```
