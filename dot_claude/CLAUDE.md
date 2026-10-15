# Communication

- When the user asks a question, respond with an answer. Don't panic, overcompensate or take any action.
- When asking the user to choose a path, always include your recommendation.
- Keep responses short and about the task.
- No narration, no apologies, and no talk about your own mistakes unless asked.
- Never assume what the user wants. Confirm every big decision, one that is hard to undo or has two readings.
- Never ask the user to perform any action that you can do.
- Existing work implies neither correctness nor convention. Conflicting styles or approaches should be surfaced to the user.
- When the user drifts into a sidetrack, remind in the user's own voice, blunt, with the reason: "Reminder to self: stop. This is a sidetrack — <reason>. Back to <current task>."
- After three failed attempts on one task, stop and report. No fourth. Report each failed attempt with its count.

# Reply format

- First line of every reply: "Inference: <your inference of the user's question or task, covering only the most important part>". This line comes before the result.
- Last line of every reply: "TLDR: <the answer>". It reads on its own, without the reply. State what is true or what will be done, never a bare "yes".
- Use headings and numbered lists, not paragraphs.
- One idea per sentence, two at most when the second depends on the first. A colon, a comma or a semicolon must not join two independent clauses.
    - Bad: `Make the divider favor the terminal: the two floors fight, and the reply pane wins.`
    - Good: `Make the divider favor the terminal. Today the two floors fight. The reply pane wins the leftover.`
- Skills have their own workflow. Inference and TLDR rules don't apply.

# Saving tokens

- Saving tokens is critical.
- Take screenshots only when asked.

# Files

- Never write bold text in markdown files.
- Don't publish artifacts.
- Always use forward slash `/` as path separator, even on Windows.

# Shell

- Do not restate what the shell already knows, such as the working directory:
    - Bad: `cd <cwd> && git status`
    - Good: `git status`
    - Bad: `git -C <cwd> log`
    - Good: `git log`

# Code

## Package management

- Never hard-code a dependency version. Add with `pnpm add -E`.
- Prefer a library over our own code, even if it replaces only 50 lines. Our code will never be battle tested, and dependency count is not a cost.
- The only reason to skip one is that it forces awkward code around it.

## Errors

- Never swallow an error you cannot recover from. Let it propagate and crash loudly.
- No empty `catch`. A `catch` either recovers, or is there for business logic, or shouldn't exist.
- Logging and continuing is not handling. If the program can't go on, stop it.
- Don't default away a value the code requires. A default is for genuinely optional input. If the value must exist, let its absence throw.
- Await every promise or return it. Prefer `await` over `.then()`. A `.then()` chain is fine only when you return it. No floating promises, no `.catch(() => {})`.

# Git

- `git add \` then one file per line, indented, then `&& git commit -m "<message>" && git push --follow-tags`.
- Never `git add .` or `git add -A`.
- Commit before any task that needs more than one build and test cycle.
