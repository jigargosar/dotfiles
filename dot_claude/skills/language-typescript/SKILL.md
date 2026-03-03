---
name: language-typescript
description: TypeScript coding conventions. TRIGGER when project contains tsconfig.json.
user-invocable: false
disable-model-invocation: false
---

- No hacks, no `as`, no `!`, etc.
- Always use `const` declarations. Usage of `let` requires strong justification.
- Use `switch` with `assertNever` for type discrimination, never `if/else` chains
