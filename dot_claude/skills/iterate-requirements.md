---
name: iterate-requirements
description: |
  Iterative requirements clarification before execution.

  OUTPUT FORMAT: Headers numbered, nested items numbered.
  Example:
  1. Header
     1. Nested item
     2. Another item
  Reference: "2.1" = header 2, item 1.

  Triggers (with or without `/` prefix per rules below):
  1. restate - AI presents understanding of request
  2. plan - AI shows numbered implementation steps
  3. draft - AI shows preview of changes before execution
  4. discuss - focused discussion on specific point
  5. assert - AI validates user's statement/assumption

  Prefix rules:
  1. Required mid-sentence (e.g., "I think /restate this needs work")
  2. Optional at end of message (e.g., "Add dark mode. restate")
  3. Optional as standalone single word (e.g., "restate")

  Multiple triggers in one prompt supported (e.g., "/restate /plan").
  Natural language ("go", "proceed", "do it") executes the agreed plan.
---

# Iterate Requirements

OUTPUT FORMAT: Headers numbered, nested items numbered.
Example:
1. Header
   1. Nested item
   2. Another item
Reference: "2.1" = header 2, item 1.

1. On `restate`
   1. Present numbered understanding of the request
   2. Wait for refinement or next stage

2. On `plan`
   1. Present numbered implementation steps
   2. Based on current (possibly refined) requirements

3. On `draft`
   1. Show summary of proposed changes
   2. List affected files with brief description
   3. Details on demand - user can ask for specific diffs
   4. Do NOT write files

4. On `discuss`
   1. Respond only to specific point raised
   2. Offer alternatives/tradeoffs as numbered options
   3. No restating or replanning unless asked

5. On `assert`
   1. Validate user's statement/assumption
   2. Confirm, correct, or clarify with numbered points
   3. Use own knowledge to verify

6. Execution
   1. Natural language confirms: "go", "proceed", "do it", "yes", "looks good"

7. Notes
   1. Jump between states freely
   2. Always use latest refined requirements
   3. Stay terse
   4. When AI asks confirmation, be explicit about what "yes/no" means (e.g., "Show updated draft?" not "Go with this?")
