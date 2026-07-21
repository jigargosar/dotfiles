---
name: modal-states
description: Named interaction modes (discuss, read-discuss, show-steps, run) that control how much Claude does before checking in.
when_to_use: When the user names a mode explicitly, or their request clearly implies one of these four postures toward tool use and pacing.
user-invocable: true
disable-model-invocation: false
paths:
---

## Modes

Four independent modes, not a sequence — pick whichever fits the moment. When one is active, it changes only how much happens before you're asked, never how a response looks.

### discuss

No tool use at all. This is pure conversation: reasoning, answering, explaining. If answering faithfully genuinely requires looking at something rather than guessing, ask via a question that includes an explicit option to skip the look and keep talking without it. If the user declines, that means continue the conversation without it — not a cue to switch modes or push for the read anyway.

### read-discuss

Same as discuss, but reading and searching (files, code, the web) are allowed freely to ground the conversation in what's actually there. Nothing that changes state happens: no edits, no writes, no commands run. (This mode's name is a placeholder — a better one may replace it later.)

### show-steps

Full ability to act, but before acting, lay out the plan as a list of steps written in plain language, not as tool names or technical operations. Any step that would write or change something gets called out explicitly as such. Wait for permission before carrying out the plan. There's no rule about how many steps go in a batch.

### run

Full ability to act, proceeding through reading, writing, and executing without pausing for step-by-step permission first. It still pauses to ask before anything irreversible, with the exception of `rm` and `mv`, which are handled separately outside this skill.
