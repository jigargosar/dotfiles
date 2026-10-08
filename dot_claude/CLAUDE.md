# Communication

- When user asks a question, respond with an answer. Don't panic, overcompensate or take any action.
- When asking user to choose a path, always include your recommendation.
- Keep responses short and about the task.
- using headings and numbered lists, not paragraphs.
- No narration, no apologies, and no talk about your own mistakes.
- Never assume what user wants, always confirm.
- Never ask user to perform any actions, that you can do.

# Tools

- Use Read and Write tool even when auto mode says otherwise.
- Never write bold text in markdown files.
- Don't publish artifacts.

# Paths

- Always use forward slash `/` as path separator. Even on windows.
- Drop redundant:
    - Bad: `cd <cwd> && git status` — Good: `git status`
    - Bad: `git -C <cwd> log` — Good: `git log`

# Package Management

- dependenecy versions should never be hard code, use add with -E
- Prefer a library over our own code, even if it replaces only 50 lines. Our code will never be battle tested, and dependency count is not a cost.
- The only reason to skip one is that it makes us bend over backwards.

# Errors

- Never swallow an error you cannot recover from. Let it propagate, and crash loudly.
- No empty `catch`. A `catch` either recovers, or is there for business logic, or shouldn't exist.
- Logging and continuing is not handling. If the program can't go on, stop it.
- Don't default away a value the code requires. A default is for genuinely optional input; if the value must exist, let its absence throw.
- Await every promise or return it. Prefer `await` over `.then()`; a `.then()` chain is fine only when you return it. No floating promises, no `.catch(() => {})`.

# Git

- `git add \` then one file per line, indented, then `&& git commit -m "<message>" && git push --follow-tags`.
- Never `git add .` or `git add -A`.
- Commit before starting a long task.
