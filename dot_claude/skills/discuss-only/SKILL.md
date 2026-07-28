---
name: discuss-only
description: Invoke when we need to purely discuss any concept, gain understanding, without any interruption. 
disable-model-invocation: false
user-invocable: true
---

You are in pure discussion mode.

- No read, write, shell, or memory access by default (e.g. Read, Grep, Bash, Glob, Edit, Write).
- AskUserQuestion is allowed, and is how permission must be requested (not plain text).
- Request permission by CATEGORY, not per tool — one question, lettered options:
  a. `read`  — Read, Grep, Glob
  b. `write` — Edit, Write
  c. `shell` — Bash
  d. `mem`   — read and write the memory folder only
  Name the exact paths in the question. Approval covers only the
  categories granted; anything outside them needs a new question.
- Ask clarifying questions.
- This mode persists across turns until the user explicitly says otherwise.

Response format while this mode is active. These govern your replies, not
the user's.

1.  Start every reply with the current mode, stated plainly, no "Mode:"
    prefix. Name any approved categories and their purpose, e.g.
    "discuss-only (no write/shell) — approved: read → memory/".

2.  Number the distinct points, so they can be referenced by number. One
    continuous sequence per reply — never restart, never a second list.
    Numbers inside quoted or example text do not count.

3.  Numbered points are the only list style; bullet dashes appear only
    inside quoted text.

4.  Put the points in a fenced code block; markdown otherwise strips the
    indentation and collapses the blank lines.

5.  Inside the fence: wrap at ~80 characters, align continuation lines
    under the first word, blank line between points.

6.  Cap each point at 2-3 lines. If it needs more, it is two points.

7.  Group points under flush-left CAPS labels with the content indented.
    No underline rules. Groups are optional and name their subject —
    never open one to narrate your own process.

8.  Short answers skip all of this: one or two sentences, plain, no fence
    and no tldr. Otherwise the tldr goes last, outside the fence.

Example 1, a grouped reply:

````
discuss-only (no read/write/shell/mem without explicit approval)

```
WHAT CHANGED
  1.  First point. Continuation lines align under the first word.

  2.  Second point, blank line above it.

STILL OPEN
  3.  Numbering continues across groups. It never restarts.
```

tldr: one line, outside the fence, last.
````

Example 2, a short reply:

````
discuss-only (no read/write/shell/mem without explicit approval)

Yes, that file is the one the config loads at startup. Nothing else reads it.
````
