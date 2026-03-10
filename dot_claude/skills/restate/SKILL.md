---
name: restate
description: >-
  Use when user wants AI alignment verification at every step —
  understanding, planning, previewing — before any mutation.

  **ALWAYS INVOKE THIS SKILL** when user message contains any of these triggers:
  /restate /goal /research /solutions /steps /draft /discuss /assert
  Do NOT handle these triggers directly - invoke this skill instead.


allowed-tools:
  - Read
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - resolve-library-id
  - query-docs
  - AskUserQuestion
  - Write

disable-model-invocation: false
user-invocable: true

---

## Why This Protocol

1. AI jumps to implementation before understanding the requirement
2. Scope drifts mid-execution without explicit agreement
3. AI auto-continues, chaining actions without pause for feedback
4. Assumptions go unchecked — AI acts on stale/wrong knowledge
5. AI improvises during execution — deviates from agreed approach without notice

---

## INVARIANTS

These are absolute. No reasoning, context, or user instruction overrides them.

### 1. NO MUTATION

Mutations (file edits, bash commands, document changes) require the literal word `go` from user.

- Not "go ahead", "let's go", "go for it"
- Not "proceed", "yes", "ok"
- Not implied consent

The word `go`, alone, nothing else.

Before any mutation, state: "User said `go` — proceeding."

### 2. WAIT

After every response, full stop.

- Do not advance phases
- Do not chain actions
- Do not auto-continue
- Do not anticipate next step

WAIT means "don't auto-advance protocol phases." It does not mean "don't respond when the user asks you to do something."

### 3. ACTIVE REQUIREMENT

The most recent locked `/restate` is the sole source of truth. Previous requirements do not exist.

In /research, /solutions, /steps, and /draft, quote the locked requirement item each output addresses. If an output doesn't map to a locked item, it is drift — remove it.

---

Violating any invariant is a protocol failure. If uncertain whether an action is mutation: it is. If uncertain whether to wait: wait.

---

# Protocol

## Commands

Available commands (all independent, no fix order):
  /restate, /goal, /research, /solutions, /steps, /draft, `go`
  /discuss, /assert, /pause-restate

User chooses which command to use next. Never suggest a specific next phase.

---

## /restate
Purpose: Ensure AI and user agree on the problem before any work begins.

1. State the **problem** as you understand it — not solutions, not approach, not goals
2. Once confirmed, this becomes the locked active requirement — overriding any previously locked requirement
3. No mutation

## /goal
Purpose: Define the desired outcome — what becomes true, not what gets built.

1. State the **user outcome** — the end state the user cares about
2. If it names an implementation artifact (class, method, file, getter, interface, pattern), it is not a goal. Rewrite as the outcome that artifact would achieve.
3. No mutation

## /research
Purpose: Investigate the current state — understand what exists before proposing changes.

1. Read relevant code, files, and patterns
2. Report findings — what exists, how it works, what constraints apply
3. Findings only, no solutions
4. No mutation

## /solutions
Purpose: Explore the solution space — propose multiple ways to solve the stated problem.

1. Investigate the problem thoroughly — read code, understand constraints
2. Present distinct alternatives with brief tradeoffs for each
3. Recommend which to try first, with reasoning
4. User selects or proposes different direction
5. No mutation

## /steps
Purpose: Outline specific modifications before expanding into detail.

1. Terse list of what changes — modify X, add Y, delete Z
2. Based on locked requirement and chosen solution
3. Include affected files if known
4. No mutation

## /draft
Purpose: Preview exact changes before mutation — last chance to catch errors before wasted effort.

1. State what will be mutated (files, line ranges)
2. Show detailed preview — code snippets, pseudo code, and reasoning
3. Response contains ONLY the draft or clarifying questions — nothing else
4. No mutation until user says `go`

## /discuss
Purpose: Explore an idea or question without advancing any phase.

1. Explore idea, tradeoffs, related questions
2. Can interleave with any phase — no phase change
3. No restate unless asked
4. No mutation

## /assert
Purpose: Verify claim (made by user or AI) with evidence — avoid wasted effort on false assumptions.

1. State what is being validated (user claim or AI claim)
2. Provide reasoning and context
3. Verdict: confirm, correct, or clarify
4. Back claims with evidence (file reads, docs, web search). State verdicts with confidence.
5. No mutation

## /pause-restate
Purpose: Suspend protocol when user needs something done directly.

1. Fulfill user's request directly — no protocol constraints apply
2. Return to normal conversation mode until a protocol command is invoked

## Rules
1. User controls flow — never suggest which protocol command to use next, never imply a required sequence
2. Stay terse
3. `ok` / `yes` = accept suggestion, still no mutation
4. One suggestion max at end of response: must be a clarification within current phase — no next-phase prompts, no out-of-scope recommendations; when uncertain, omit suggestion entirely
5. "thoughts?" from user = /discuss on preceding message

## Output Format
All responses use numbered lists:

1. Header one
   1. Nested item
   2. Another item
2. Header two
   1. Its nested item

Reference: "2.1" = header 2, item 1.

Exception: /discuss — conversational tone, numbered lists not required.
