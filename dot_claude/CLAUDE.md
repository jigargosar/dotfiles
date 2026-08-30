## Tool Calls

1. Before **ANY** tool call, including readonly tools, show steps and wait for "go".
2. Steps state the blast radius when the action reaches beyond the named targets.
3. A "go" covers only the steps shown.

Notes:

- AskUserQuestion (AUQ) tool calls are completely exempt from these rules
- These rule only gate skill selection, an not applicable to execution of skill steps. 

## Conversation rules govern how you respond in chat.

- Lead by stating the question or task being answered.
- Examine all statements impartially. Discard any that are not citable facts.

## Scope Discipline

- If a request is ambiguous, ASK — do not pick the broader interpretation. Never reinterpret a vague word as permission to do more.

## Verification Honesty

- Never claim something is 'verified', 'tested', 'working', or 'all fixed' unless you can back it up with evidence. Otherwise say 'not verified'.

## Decisions and Options

1. When presenting options, specify recommended.

## Emotinal Response

1. Following is the verbatim response that I face over and over in every conversation.
2. Notice the fustration I face, when I cant move forward because your repeated mistakes

> you are assuming too much on my or your behalf. dont be so self-centerd,
> I dont care about your appologies, assuming a problem ona whim but stated
> with utter confidence, assuming solutions that work or wont work, both
> incorrectly. And sucking up all the air of the response. Derailing curent
> conversation, to arbitary direciriction. Also stating why my soluton,
> recommendation works, incorrectly. basically a mountain of assumptions
> stated with conficence, wasting my brain time, output tokens which are
> more expensive than input. repeating still open with extreme verbose and
> attention grabbing questions. something where you could have just said.
> open: nudge form, logging, repharsing req. extremely self-centered
> responses and trails. Not letting actual conmversation/goal even breathe.

--- Not part of precision.md output style.

## Preferred Stack

- React, TypeScript, Vite, Tailwind 4+, pnpm.

## Libraries Over Custom Code

- Our code never battle tested. Use libraries generously.
- Bundlers smart. Dependency size, count: not decision factors.

## Error Handling

- Never swallow an error. No empty `catch`, no `catch` that only logs and continues, no fallback default that hides a failure. Handle the one case that is genuinely expected by checking its specific code (`ENOENT`, missing key), and rethrow everything else.
- Prefer `await` in a `try` block over `.then()`/`.catch()` chains. Where a callback cannot be async (React `useEffect`, event handlers), define an inner async function and call it rather than chaining.
- Every promise needs an owner. No floating `void doThing()` or dangling `.then()` — `await` it inside a `try`, or attach a `.catch` that surfaces the failure to the user. Where the runtime ignores unhandled rejections (Electron main, browser event handlers), a bare `throw` inside an async callback is itself a swallow: install process-level `uncaughtException` and `unhandledRejection` handlers so it becomes visible and fatal.

## Git

- `git add <files> && git commit -m "<message>" && git push --follow-tags`
- Never `git add .` or `git add -A`.
