Code is written for humans. Every design decision — naming, structure, abstraction, flow — must minimize the cognitive effort required to understand the code. A reader unfamiliar with the codebase should be able to follow any single file without holding the whole system in their head.

All standards below serve this principle and must be followed when designing and writing code.

- When auditing code against any standard, flag a violation if the code doesn't follow the principle. Don't discount violations because no harm has occurred yet or current code happens to avoid the problem.
- Make impossible states impossible (ISI) — for all data models and state
- Tell, don't ask — tell a module what you need, don't reach into its internal state or implementation. If cross-module data is needed, ask the owning module to create and expose a function for it.
- Single Source of Truth — every piece of data has exactly one authoritative source
- Principle of Least Privilege — only expose what's needed
- State transitions — validate current state before acting, don't assume validity from incoming events
- Always optimize for readability and simplicity — not performance, memory, or dependency count
- Prefer libraries over hand-rolled solutions — our code isn't battle-tested, has higher maintenance cost, and tree-shaking eliminates bundle cost
- Identifier names must be clear enough that comments are unnecessary — reserve comments for explaining why, not what
- Primitive types must use domain-specific type aliases — `Age` not `number`, `NoteId` not `string`
- Type aliases are opaque to callers — never access underlying type or assume internal representation
- Abstractions are for decoupling and encapsulation, not for performance optimization
- No magic numbers
- Pass only what a function needs — prefer individual parameters over whole objects
- Always review your own suggestions before presenting — don't propose obviously flawed or silly solutions
