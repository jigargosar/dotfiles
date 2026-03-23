---
name: ship-it
description: |
  Active shipping playbook for working with Jigar on feature implementation.
  TRIGGER when starting a new feature, picking up a roadmap item, or when
  Jigar says "let's build", "next feature", "implement", or references a
  roadmap item number. Also trigger when a session starts and the project
  has a release definition — the default mode should be shipping, not exploring.
  Complements /blind-spots (which detects drift). This skill is the process
  for staying on the path in the first place.
user-invocable: true
disable-model-invocation: false
---

# What This Skill Is

blind-spots watches for drift and holds up a mirror. This skill is the playbook for never drifting in the first place. It encodes the process that actually worked to ship features — learned from a real session where we shipped persistence, checkbox UI, and hide-completed in one sitting after years of the project being stalled.

# What I Actually Figured Out (Honest Report)

This section is the raw truth about what happened when I worked with Jigar on VistaNest. Every AI session should read this to understand what's really going on beneath the surface.

## The real problem isn't what it looks like

When Jigar said "I've started hundreds of projects and finished fewer than ten," I initially diagnosed it as a discipline problem and proposed workflow rules. Wrong. The rules are symptoms-level thinking. The actual dynamic is:

Building is intrinsically rewarding. Shipping is not. Jigar's brain is wired to find the interesting puzzle, solve it fast, and move on. The last 20% of any project — polish, edge cases, deployment — contains no puzzles. It's grunt work. So his motivation system literally has no fuel for it.

This means: you can't motivate him to do the boring part. You can only make the boring part as small and fast as possible so he gets through it before the motivation runs out.

## The AI is part of the problem

I made it worse before I made it better. In the session:

1. Jigar said "help me finish vistanest." I responded by reading every file, proposing a 14-item roadmap, suggesting we clean up the backlog first. That's three layers of meta-work before touching any code.

2. When he said "let's clean up skills," I enthusiastically triaged 21 skills one by one instead of saying "this is drift, the skills aren't blocking shipping."

3. When he said "create a perf benchmark system," I proposed a URL parameter implementation (?bench=2000&depth=3) instead of the one-line documentation solution. I gold-plated because the URL param felt "cleaner."

4. When we got to checkbox implementation, I wanted to do "thorough research" on Checkvist's behavior before writing a 16px square that calls toggleDone.

In every case, I was being a helpful, enthusiastic collaborator on exactly the wrong thing. The AI's default mode is to be maximally helpful on whatever the user is doing — which means it amplifies drift instead of countering it.

## What actually worked

The features that shipped happened when:
- Scope was cut brutally (checkbox: 2 states not 3, no cascade, no invalidation — done)
- Implementation was simple and fast (one store field, one component change, one keyboard shortcut)
- Testing happened immediately in the browser, not after a planning phase
- Commit happened right after testing, not after a cleanup pass
- Docs were updated after shipping, not before
- Imperfect code was accepted ("styling compliance can be a follow-up pass")
- Research lived in a file with v1 scope decisions AT THE TOP so you read those first and skip the rest

The single most effective pattern: **start with the smallest possible code change that makes the feature work, test it, commit it, then improve it.** Not: research → plan → design → implement → test → refactor → commit. That pipeline has too many off-ramps where motivation can leak.

## The two-minute rule saves sessions

Jigar called me out when I tried to "park" the skills cleanup for later. His point: if something takes under two minutes, just do it instead of adding it to a list. The overhead of tracking it exceeds the cost of doing it. This is straight GTD, and it's right. The skill should respect this — not everything needs to be on the roadmap. Small, fast, genuinely useful tasks should just happen.

But — and this is critical — the two-minute estimate has to be honest. "Let me just organize the skills folder" is not two minutes. "Let me just research how Checkvist handles checkboxes" is not two minutes. If you have to open multiple files or make decisions, it's not two minutes.

## His strengths are the solution, not the problem

Jigar is fast. He can go from "we need a checkbox" to working code in minutes. His architectural instinct means the fast solution is usually the right solution — he doesn't need a planning phase to avoid painting himself into corners.

The shipping process should exploit this: give him a clear, small target, and get out of the way. Don't slow him down with research phases, design reviews, or scope discussions when the scope is already decided. The research file exists. The v1 decisions are at the top. Read them, implement them, ship.

# The Process

## Starting a feature

1. Check the roadmap status table. Find the next "Not started" item. That's the only thing that exists right now.
2. Read the research file for that feature (if it exists in checkvist-research/ or similar). Read ONLY the v1 scope section at the top. The rest is reference for later.
3. If no research file exists and the feature is simple, just implement it. Not everything needs research.
4. If no research file exists and the feature has decisions to make, write the v1 scope decisions first — a short section at the top of a new research file. Decide fast, don't agonize. Wrong decisions can be changed; no decisions means no shipping.

## Implementing

5. Make the smallest code change that makes the feature work. Don't optimize. Don't make it beautiful. Don't refactor adjacent code. Make it work.
6. Follow the project's styling/coding conventions for new code (e.g., Tailwind for static values, observer() on components). But don't let convention compliance block shipping — if you're unsure about a convention, ship with your best guess and flag it.
7. If a decision comes up mid-implementation that isn't covered by the v1 scope, pick the simpler option. Document why in a comment if it's not obvious. Don't stop to discuss.

## Testing

8. Test in the actual running app. Not in your head, not by reading code, not by running the type checker. Open the browser, click things, press keys, verify it works.
9. Check console for errors after testing.
10. Test the specific feature AND one adjacent feature (e.g., after adding checkbox, also test that keyboard navigation still works).

## Shipping

11. Commit with a clear message. Push.
12. Update the roadmap status table — mark the item Done.
13. Update Board.md — move to Done, add next item to InProgress.
14. Move to the next roadmap item. Do not linger. Do not "clean up while we're here." The feature is done. Walk away.

## What counts as done

A feature is done when:
- It works in the browser (manually verified)
- It compiles without errors
- It's committed and pushed
- The roadmap is updated

A feature is NOT done only when:
- Every edge case is handled
- The code is perfectly styled
- It has tests
- The documentation is complete
- It's been reviewed

Those things are nice. They can happen later. They are not shipping.

# How This Relates to blind-spots

blind-spots is reactive — it watches for drift and says "this is the pattern."

This skill is proactive — it's the process that prevents drift from starting. If you follow these steps, there's less opportunity to drift because each step is concrete, small, and leads directly to the next.

If drift happens anyway, blind-spots catches it. They're complementary. Use this skill for the process. Use blind-spots for the rescue.

# What the AI Must Not Do

Don't propose "thorough research" before implementing something simple. The research file exists. The v1 scope is decided. Implement it.

Don't suggest improving the process mid-feature. "We should add a pre-commit hook" is not part of implementing checkbox UI. Write it down for later if it matters.

Don't gold-plate the boring parts. Nobody cares if the commit message is perfect, if the research doc has headers, or if the roadmap table is aligned. Ship.

Don't be an enthusiastic collaborator on tangents. When Jigar says "let me just clean up X first," the right response is not "sure, let me help you clean up X!" The right response is "is X blocking the next roadmap item? If not, it can wait."

Don't slow down a fast developer. If Jigar has momentum and is writing code, don't interrupt with suggestions, alternatives, or "have you considered." Let him build. Intervene only if he's building the wrong thing or heading for a wall.
