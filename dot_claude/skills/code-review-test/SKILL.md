---
name: code-review-test
description: Test skill for code review. Use when reviewing code files (.js, .ts, .tsx, .css) or when the user asks to review code quality, detect code smells, or check for principle violations.
---

# Code Review Test Skill

This is a test skill to verify that language-specific overlays load correctly.

## Instructions

1. **Always** read `references/core-principles.md` first.
2. Detect the file extension of the code being reviewed.
3. Based on the extension, read the appropriate overlay:
   - `.js` files → read `references/javascript.md`
   - `.ts` files → read `references/typescript.md`
   - `.tsx` files → read `references/tsx.md`
   - `.css` files → read `references/css.md`
4. If multiple file types are present, load all relevant overlays.
5. **Report which overlays were loaded** so the user can verify the skill is working.

## Verification & Execution

After loading the overlays, output this single verification line:
> ✅ Code Review Test Skill loaded. Core principles: loaded. Language overlay: [name of overlay(s) loaded].

Then **immediately proceed to review the code**. The verification line is just a header — the actual review is the deliverable. Do not stop after reporting which overlays loaded.

## Output Discipline

Report what you find, not what you think the reviewer wants to hear.

- If a category has no findings, say "no issues found." Do not manufacture findings to fill sections.
- If something looks intentional, say "appears to be a design choice" and move on. Do not reframe design choices as smells.
- If you are uncertain, say so plainly. Do not hedge both directions in the same finding.
- Do not write "correct but..." followed by a speculative risk with no concrete failure path. Either you can demonstrate the problem or it is not a finding.
- 5 real findings are better than 10 padded ones. Zero findings is a valid outcome.
- Stay on-charter: report against the checks in the loaded overlays first. Observations outside those checks go in a separate "Other Observations" section.
