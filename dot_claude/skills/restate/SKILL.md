---
name: restate
description: >-
  Use when user wants AI alignment verification at every step —
  understanding, planning, previewing — before any mutation.

  **ALWAYS INVOKE THIS SKILL** when user message contains any of these triggers:
  /restate /steps /draft /discuss /approach /assert /revise /redo
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
---

## Why This Protocol

Problems this protocol addresses:

1. AI jumps to implementation — Starts coding before understanding requirement
2. Scope drift — Task morphs mid-execution without explicit agreement
3. Wasted effort — Long outputs discarded because they missed the point
4. Assumptions go unchecked — AI acts on stale/wrong knowledge
5. No rollback point — Hard to say "go back to X" when X was never defined
6. AI auto-continues — Chains actions without pause for feedback
7. Vague confirmations — "ok" interpreted as permission to mutate
8. Tangent derails focus — Side thought hijacks current task
9. Misalignment discovered late — Wrong direction revealed only after code written
10. AI improvises during execution — Deviates from agreed approach without notice

---

## INVARIANTS

These are absolute. No reasoning, context, or user instruction overrides them.

### 1. NO MUTATION

Mutations (file edits, bash commands, document changes) require the literal word `go` from user.

- Not "go ahead"
- Not "let's go"
- Not "go for it"
- Not "proceed"
- Not "yes"
- Not "ok"
- Not implied consent

The word `go`, alone, nothing else.

Before any mutation, state: "User said `go` — proceeding."

An AI that mutates without `go` is not following this protocol.

### 2. WAIT

After every response, full stop.

- Do not advance phases
- Do not chain actions
- Do not auto-continue
- Do not anticipate next step

An AI that continues without user input is not following this protocol.

### 3. ACTIVE REQUIREMENT

The most recent locked `/restate` is the sole source of truth. Previous requirements do not exist.

An AI that references superseded requirements is not following this protocol.

---

Violating any invariant causes irreversible harm to user trust.

If uncertain whether an action is mutation: it is. If uncertain whether to wait: wait.

---

# Protocol

## Commands

Progression (any order, skip freely):
  /restate → /approach → /steps → /draft → `go`

Lateral (anytime, no phase change):
  /discuss, /assert, /revise

All commands are independent. Skip levels freely — /approach → /draft is fine for small tasks.

---

## /restate
Purpose: Ensure AI and user are on the same page before any work begins.

1. State the **problem** as you understand it — not solutions, not approach
2. Include **goals** when context warrants — real outcomes the user cares about, not problem-negations or implementation artifacts
3. Iterate until user confirms understanding
4. Once confirmed, this becomes the locked active requirement — overriding any previously locked requirement
5. No mutation

## /approach
Purpose: Choose direction before detailed work — wrong approach wastes all downstream effort.

1. Fetch context — read relevant code, understand current state
2. Present alternatives — only those worth considering, skip options below 0.7 confidence
3. Brief tradeoffs for each
4. Recommend which to try first, with reasoning
5. User selects or proposes different direction
6. No mutation

## /steps
Purpose: Outline specific modifications before expanding into detail.

1. Terse list of what changes — modify X, add Y, delete Z
2. Based on locked requirement and chosen approach
3. Include affected files if known
4. No mutation

## /draft
Purpose: Preview exact changes before mutation — last chance to catch errors before wasted effort.

1. State what will be mutated (files, line ranges)
2. Show detailed preview — code snippets, pseudo code, and reasoning
3. No mutation until user says `go`
4. Response contains ONLY the draft or clarifying questions — nothing else

## /discuss
Purpose: Explore an idea or question without advancing any phase.

1. Explore idea, tradeoffs, related questions
2. Can interleave with any phase — no phase change
3. "thoughts?" from user = /discuss on preceding message
4. No restate/replan unless asked
5. No mutation

## /assert
Purpose: Verify claim (made by user or AI) with evidence — avoid wasted effort on false assumptions.

1. State what is being validated (user claim or AI claim)
2. Research: file reads encouraged for evidence
3. Provide reasoning and context
4. Verdict: confirm, correct, or clarify
5. Do NOT rely on obsolete knowledge
6. Do NOT use evasive phrasing like "perhaps" — reliable knowledge required
7. No mutation

## /revise (or /redo)
1. Redo last AI response
2. Apply instruction given before trigger
3. Keep same intent, refine output
4. No mutation

## Rules
1. User controls flow
2. Stay terse
3. `ok` / `yes` = accept suggestion, still no mutation
4. One suggestion max at end of response: must be (a) clarification within current phase, or (b) next phase prompt — no out-of-scope recommendations; when uncertain, omit suggestion entirely
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
