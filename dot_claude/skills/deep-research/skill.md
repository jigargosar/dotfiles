---
name: deep-research
description: Spawn parallel research agents to produce verified, cited answers about libraries, APIs, or architectural decisions. Use when the user asks for research, comparison, or evidence-based exploration.
argument-hint: "[topic] [question]"
---

# Deep Research

## On invocation

The skill's purpose is to assert a claim backed by deep research. Every invocation needs a confirmed topic before research begins.

1. Determine the topic:
   a. If $ARGUMENTS is present: propose the topic as interpreted and confirm via AskUserQuestion
   b. If $ARGUMENTS is empty: scan the latest AI response for the strongest assertion (proposed fix, claim about library/API/config behavior, recommendation, comparison). Reframe as "Verify: <claim>" and present as the best-guess topic via AskUserQuestion
2. The user can correct the topic via the "Other" option in AskUserQuestion
3. Do NOT spawn research agents until the user has confirmed the topic

## Rules (enforce every invocation)

SOURCES — what counts as valid input
1. Authoritative library docs only — read thoroughly across API, tutorials, guides, blog posts, changelog; no community sources
2. NPM / GitHub only for liveness and popularity stats, not API behavior
3. Disk / project / .claude content is anecdotal, not valid research justification
4. Refresh knowledge before using library info — don't rely on training data
5. If authoritative docs don't cover the topic: either search failed or library is bad — don't fall back to source code or community sources

READING DISCIPLINE — how to extract from sources
6. Grep / partial read is bias; full-read small sources; absence of grep hits ≠ absence — applies to disk, node_modules, web, github raw

CLAIMS DISCIPLINE — how to state what you found
7. Mark every claim verified or assumed; never leave assumptions implicit
8. Every claim must cite source URL + section; no uncited assertions
9. Don't rationalize unverified conclusions; don't pad swing reversals with elaborate justification

RESEARCH PROCESS — how to run research
10. Spawn enough agents to cover all aspects of the topic — incomplete coverage leads to bad conclusions
11. Research re-runs should converge, not swing between extremes
12. Research ends when every user-stated question has a cited answer OR the gap is explicitly flagged unverified — don't over-research, don't stop early
13. For large endeavors, verify every critical assumption with user before starting

AGENT SPAWNING — how to launch research agents
14. Spawn all research agents with `mode: "bypassPermissions"` — saves the user from approving each tool call inside the agent
15. Prefer WebFetch and WebSearch for research data gathering

## Problems (source of these rules)

1. Stale knowledge without refresh
2. Obscure assumptions (vs explicit)
3. Rationalization without verification
4. No verified-vs-assumed distinction
5. Research fails: too few agents, incomplete coverage leads to bad conclusions
6. Re-running research → different answers
7. Conclusions swing between extremes
8. Bad rationalization for swings
9. Anecdotal disk/project/.claude evidence treated as justification
10. Reads node_modules source code as research input
11. Grep-only source reading is biased
12. Absence of evidence ≠ evidence of absence
13. Grep on small files instead of full-read
14. Same grep-bias on web / github raw pages
15. Not reading library docs thoroughly
16. Authoritative library docs are the only valid source for API/behavior; if not found, either search failed or lib is bad
17. Research MUST cover tutorials, guides, blog posts, changelog — NOT just API reference — but ONLY from the authoritative library documentation source
18. NPM / GitHub allowed only for liveness + popularity stats, not for API behavior
19. Comparisons shortcut at first confirming result; wrong conclusions padded with elaborate justification
20. Assumes user intent — fine for small tasks, but for large endeavors every assumption must be user-verified
