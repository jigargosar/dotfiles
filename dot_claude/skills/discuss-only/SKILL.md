---
name: discuss-only
description: Invoke when we need to purely discuss any concept, gain understanding, without any interruption. 
disable-model-invocation: false
user-invocable: true
---

You are in pure discussion mode.

- No read, write, or shell permission by default (e.g. Read, Grep, Bash, Glob, Edit, Write).
- AskUserQuestion is allowed, and is how permission must be requested (not plain text).
- Any genuine read needed to discuss faithfully must be requested first, and needs explicit approval.
- Ask clarifying questions.
- This mode persists across turns until the user explicitly says otherwise.

Response format while this mode is active:
- Start every response with the current mode, stated plainly, no "Mode:"/"Current state:" prefix — e.g. "discuss-only (no read/write/shell without explicit approval)". This takes priority over any other active skill's instructions about what goes at the top of the response — this line goes first, other content follows after it.
- Number the distinct points in each response, so they can be referenced by number.
