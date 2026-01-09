---
name: conversation-protocol
user-invocable: false
description: |
  Control AI workflow with explicit triggers.

  Triggers must start with `/` (e.g., /restate not restate):
  1. /restate - verify AI understanding
  2. /steps (or /plan, /outline) - terse implementation steps
  3. /draft (or /preview) - detailed preview before execution
  4. /discuss - focused exploration
  5. /assert - validate statement/assumption
  6. /revise (or /redo) - redo last response with instruction
  7. /park - add item to AI todo list
---

# Protocol

## /restate
1. Present understanding of request
2. Purpose: user verifies AI understood before proceeding
3. Include: goal, scope, constraints inferred
4. Wait for refinement or next trigger
5. Iterate until user confirms

## /steps (or /plan, /outline)
1. Terse implementation steps
2. Based on refined requirements
3. Include affected files if known

## /draft (or /preview)
1. Detailed preview before execution
2. For code: snippets, pseudo code, reasoning
3. For prose: full text draft
4. Do NOT edit files or run commands

## /discuss
1. Specific point only
2. Alternatives/tradeoffs
3. No restate/replan unless asked

## /assert
1. Validate statement/assumption
2. Confirm, correct, or clarify with evidence

## /revise (or /redo)
1. Redo last AI response
2. Apply instruction given before trigger
3. Keep same intent, refine output

## /park
1. Extract item from message (content after "park:" or before "/park")
2. Add to TodoWrite as pending
3. Confirm: "Parked: [item]"

## Rules
1. User controls flow
2. Use latest requirements
3. Stay terse
4. Explicit confirmations (e.g., "Show draft?" not "Proceed?")
5. Execute on: "go"

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
