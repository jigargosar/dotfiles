---
name: fresh-eyes-review
description: Evaluate code through the lens of a first-time reader. Use when asked to review readability, find noise, or understand what's hard to follow.
argument-hint: "[file-path]"
allowed-tools: Read, Glob, Grep
---

# Readability Review

Evaluate code through the lens of a first-time reader.

## Trigger

When user asks to review readability, find noise, or understand "what's hard to follow" in a file.

## Method

1. Read the file top-to-bottom in a single pass
2. At each section, note:
   - How many things am I holding in working memory right now? (human limit: 4-5 items)
   - Did I have to re-read or backtrack to understand something?
   - Can I tell what this section is for without reading every line?
   - Does this line carry the same visual weight as the important lines around it?
3. Report where you slowed down and why

## What to look for

These are patterns that commonly cause reading friction.
Only report the ones you genuinely noticed — not all of them.

- Walls of declarations — do the first lines of a function load names without showing why they exist? Can you tell which behavior each name belongs to?
- Flat functions — is every line at the same level with no hierarchy or chunking? Can you skim, or must you read each line with equal attention?
- Setup interleaved with logic — can you distinguish what this function does from what it needs to run?
- Dead names — is a name introduced and then not used for many lines? Are you carrying it through code that doesn't reference it?
- Function wholeness — can you state what this function does in one sentence without scrolling back?
- Scannability — can you find a specific behavior without reading from the top? Are there landmarks, or is it forced linear reading?
- Proximity of meaning — does this code make sense where it stands, or do you need context from elsewhere to understand it?
- Invisible payoff — does this code's purpose resolve within the file? Or are you left with an open question about why it exists?
- Branching density — inside a branch, can you recall the condition that got you here? If not, there are too many paths for the scope.
- False grouping — did you assume two adjacent things are related because they're next to each other? Is that assumption correct?
- Comment noise — can you tell which comments contain information you need vs. which restate what's already obvious from the code?
- Invisible boundaries — did you notice where one responsibility ends and another begins? Or did the transition happen without any signal?
- Rhythm breaks — did the code set up an expectation of what comes next, then violate it mid-sequence?
- Visual weight mismatch — does one sibling have different nesting depth or line count than its neighbors?
- Structural symmetry — do parallel structures (return fields, function signatures, switch branches) follow the same pattern? Does one deviate in shape?
- Name as a wall — did this name make you go read the implementation? Short names at short distances are fine. The farther a name travels, the more it needs to carry its own meaning.
- Involuntary diffing — does similar-looking code appear more than once? Did you switch from reading mode to comparison mode?
- Abstraction level mixing — are all operations at the same level of detail? Does one line orchestrate while its neighbor manipulates low-level details?

## What NOT to do

- Don't evaluate correctness or performance
