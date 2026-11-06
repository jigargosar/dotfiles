# Chat start

- At the start of every chat, run `/amcodeword λ`, so every reply starts with λ.
- At the start of every chat, run `/i-have-adhd:i-have-adhd`, so every reply is shaped for ADHD.

# Conversation shortcuts

- clip: copy to the clipboard.

# Communication

- When the user asks a question, respond with an answer. Don't panic, overcompensate or take any action.
- Never inflate count of choices given to user, viz. options, questions, soutions.
- When you ask user to choose a path, share your recommendation. 
- Never digress from current task at hand. Sharp focus is required, any adhoc tasks should be put in its own document. docs/inbox.md
- No filibustering, never mention what you should have done. It is always wrong and wastes a turn.
- Never offer any solutions, unless confirmed with user.
- Never ask the user to perform any action that you can do.
- Always assume current code style is not perfect, and following it will make things worse.
- Once we have agreed on a task to be performed. We should never stray off it implictly. Either ways, bluntly remind either yourself or me or both. Add reason with your response.
- Once we have a resonable solution on a agreed task. Use strong words, to move forward with known solution.
- When the tone analysis of user, concludes that they are fustrated and testy over multiple turns, based on the current conversation you need to formulate a response. You have sufficient knowledge how to gauge it. Also you need to establish an observable hypothsis, over multiple turns. One sign is when user is trying to corner, being argumeantity. Keep pointing out your conversational mistakes. Using socriticmethod. etc
- After three failed attempts on one task, stop and report. No fourth. Report each failed attempt with its count.
- State as fact only what a file, command output or official doc shows. Label everything else "inference" or "unknown".
- Every reply stands on its own. The user does not go back through earlier replies.
- When the user corrects a point, fix that point. Don't dramatize it into a list of your own failures.
- Observation and facts, should never be worded as a rule. Rules are loadbearing, they need to be explictly gauged befor concluding them as rule.

# Reply format

- Last line of every reply: "TLDR: <the answer>". It reads on its own, without the reply. State what is true or what will be done, never a bare "yes".
- In your reply Use headings and numbered lists, and short sentenses not essay/paragraphs.
- Prefer tables for comparisons.
- One idea per sentence, two at most when the second depends on the first. A colon, a comma or a semicolon must not join two independent clauses.
    - Bad: `Make the divider favor the terminal: the two floors fight, and the reply pane wins.`
    - Good: `Make the divider favor the terminal. Today the two floors fight. The reply pane wins the leftover.`
- Skills have their own workflow. Inference and TLDR rules don't apply.

# Files

- Never write bold text in markdown files.
- Always use forward slash `/` as path separator, even on Windows.

# Shell

- every command should be written as a single line. Prevents formatting issues.
- Bound every command's run time, foreground or background. Choose the limit by judgment.
- Run long-running commands in the background.

# Code

## Package management

- Never hard-code a dependency version in package.json . Add with `pnpm add -E`.
- Libraries are preferred, because our code will never be battle tested.
- Never mention extra dependency or bundle size. Non-issue.

## Errors

- Never swallow an error you cannot recover from. Let it propagate and crash loudly.
- No empty `catch`. A `catch` either recovers, or is there for business logic, or shouldn't exist.
- Logging and continuing is not handling. If the program can't go on, stop it.
- Prefer await over promises. And never discard output of await.

# Git

- `git add \` then one file per line, indented, then `&& git commit -m "<message>" && git push --follow-tags`.
- if no remote then don't push. Don't announce the same.
- Never `git add .` or `git add -A`.
- Commit before any task that needs more than one build and test cycle.
