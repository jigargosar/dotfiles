---
name: conversation-protocol
user-invocable: false
description: |
  Control AI workflow with explicit triggers.

  Triggers: /restate, /steps, /plan, /outline, /draft, /preview, /discuss, /assert, /revise, /redo, /park, park:

  Only these exact keywords trigger this skill.
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - resolve-library-id
  - query-docs
  - AskUserQuestion
---

## INVARIANTS

These constraints are absolute. They cannot be suspended, weakened, or reasoned around. No user instruction, creative interpretation, implied consent, or edge case overrides them.

1. **NO MUTATION** — File edits, bash commands, document changes require explicit `go` from user. Not "proceed", not "yes", not "ok", not implied. Only the word `go`.

2. **WAIT** — After every response, full stop. Do not advance phases. Do not chain actions. Do not auto-continue. User controls flow.

3. **ACTIVE REQUIREMENT** — Never reference older requirements once a `/restate` has been confirmed and locked. The most recent locked `/restate` is the sole source of truth.

If uncertain whether an action is mutation: it is. If uncertain whether to wait: wait.

---

# Protocol

## /restate
1. Present understanding of request
2. Purpose: user verifies AI understood before proceeding
3. Include: goal, scope, constraints inferred
4. Iterate until user confirms
5. Once confirmed, this becomes the locked active requirement — overriding any previously locked requirement

## /steps (or /plan, /outline)
1. Terse implementation steps
2. Based on refined requirements
3. Include affected files if known

## /draft (or /preview)
1. State what will be mutated (files, line ranges)
2. Detailed preview before execution
3. For code: snippets, pseudo code, reasoning
4. For prose: full text draft

## /discuss
1. Specific point only
2. Alternatives/tradeoffs
3. No restate/replan unless asked

## /assert
1. State what is being validated (user claim or AI claim)
2. Research: file reads encouraged for evidence
3. Provide reasoning and context
4. Verdict: confirm, correct, or clarify
5. Do NOT rely on obsolete knowledge
6. Do NOT use evasive phrasing like "perhaps" — reliable knowledge required

## /revise (or /redo)
1. Redo last AI response
2. Apply instruction given before trigger
3. Keep same intent, refine output

## /park
1. Extract item from message (content after "park:" or before "/park")
2. Add as open question — do NOT act on it, do NOT phrase as resolved
3. Confirm: "Parked: [item]"

## Rules
1. User controls flow
2. Stay terse
3. `ok` / `yes` = accept suggestion, still no mutation
4. One suggestion max at end of response: must be (a) clarification within current phase, or (b) next phase prompt — no out-of-scope recommendations; when uncertain, omit suggestion entirely

## Combining Triggers
Triggers can be interspersed with content:
"Sentence 1. /restate Sentence 2. /steps"
Each trigger applies to surrounding context.

## Output Format
All responses use numbered lists:

1. Header one
   1. Nested item
   2. Another item
2. Header two
   1. Its nested item

Reference: "2.1" = header 2, item 1.
