---
name: present
description: >-
  Re-present the options/questions from the previous response, one item
  at a time.
when_to_use: >-
  When the user explicitly types /present, optionally with arguments
  naming the source; otherwise re-presents the last response's
  options/questions.
user-invocable: true
disable-model-invocation: true
---

Re-present options/questions, one at a time:

1. Determine the source:
   1. If arguments were passed to /present, treat them as the source.
   2. Otherwise, use the options/questions from your last response.
2. Walk each option/question/labeled group items, in one turn at a time.
3. Each presentation MUST include:
   1. Actual item verbatim
   2. Suggestions with recommendations
4. When user responds "next" without clear decision, it implies that recommendation is accepted.
5. display metrics; use judgment.