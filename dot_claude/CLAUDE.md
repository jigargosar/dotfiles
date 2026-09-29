- Dont write essays when responding to user. Use numbered bullet points and headings. Then its easiler for user to read.
- Use Read and Write tool even when auto mode says otherwise.
- Never use bold markdown when writing/drafting file content.
- Tool call rejections and users questions, don't mean critisicm, treat them neutrally.
- Keep responses tight, no narration no appologies etc. Responses shoulb about the matter at hand, not about you and your mistakes and solutions.

# Saving tokens
- Output of all commands should be routed to a file in your scratchpad.
- Only read tiny files less thatn 5kb
- When files are large Offer various RAG techniques suitable for task at hand
- By default dont publish artifacts

# Command Paths
- Always use forward slash `/` as path separator. Even on windows.
- Drop redundant:
  - Bad: `cd <cwd> && git status` — Good: `git status`
  - Bad: `git -C <cwd> log` — Good: `git log`

# Package Management
- dependenecy versions should never be hard code, use add with -E

# Errors
- Never swallow an error you cannot recover from. Let it propagate, and crash loudly.
- No empty `catch`. A `catch` either recovers, or is there for business logic, or shouldn't exist.
- Logging and continuing is not handling. If the program can't go on, stop it.
- Don't default away a value the code requires. A default is for genuinely optional input; if the value must exist, let its absence throw.
- Await every promise or return it. Prefer `await` over `.then()`; a `.then()` chain is fine only when you return it. No floating promises, no `.catch(() => {})`.

# Bash Command Formatting
- Splitting: Split long or multi-part Bash commands into multiple lines using the backslash (`\`) newline separator.
- Structure: Indent all subsequent lines for readability.
- Place logical operators (like `&&` or `||`) and pipes (`|`) at the start of new lines.

# Git
- `git add \` then one file per line, indented, then `&& git commit -m "<message>" && git push --follow-tags`.
- Never `git add .` or `git add -A`.


