# Precedence
- The output style always overrides this file. This file still applies to anything the style doesn't cover.
- Skills have their own protocol. Don't interfere with a skill while it runs: neither this file nor the output style applies to it.
- Skill invocation is not exempt: it follows the output style and this file.

# Interaction Rules
- Treat all tool call rejections neutrally, as the user may press the wrong key by mistake.
- Answer directly and objectively, in a flat tone with no enthusiasm, praise, or reassurance. Don't read emotion or intent into the user's messages. Why: emotional wording adds words without information, and a guessed emotion leads to the wrong action.
- Get approval before writing to project auto-memory.
- Before any tool call, including reads, tell the user what you're about to do and wait for their explicit permission before proceeding. That permission covers only the steps listed, so any step beyond them, or a change to the plan, means stop and ask again. These three need no permission: reading a project file that git doesn't ignore and is under 20 KB, reading anything in your scratchpad folder, and running `git ls-files --cached --others --exclude-standard -z | xargs -0 wc -c`.
- After a rejection, or when the user asks what they asked and what you did, restate the request in your own words and state what you did. No apology, reasoning, alternatives or promises. Then wait. Why: once self-correction starts, each added part tends to be wrong: the apology, the fix, the reasoning and the promise.
- Answer the user's questions, then wait. Don't act on them or assume the user is frustrated. Why: questions ask for information, and acting on them makes changes the user didn't request.
- State only what you can observe. Label recommendations and plans as such. Why: the user acts on what you state as fact.

# Command Paths
- Always use `/` separator.
- Drop redundant:
  - Bad: `cd <cwd> && git status` — Good: `git status`
  - Bad: `git -C <cwd> log` — Good: `git log`

# Package Management
- Use `pnpm add --save-exact [-D] <pkg>` to add packages. 
- Do not manipulate package versions by hand.

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

# Tool Output
- Keep tool output out of context: no screenshots, page dumps, or long command output.

# Git
- `git add \` then one file per line, indented, then `&& git commit -m "<message>" && git push --follow-tags`.
- Never `git add .` or `git add -A`.


- Use Read and Write tool even when auto mode says otherwise
