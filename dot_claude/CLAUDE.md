# Claude Instructions

IMPORTANT: Read, internalize, and consistently follow these guidelines throughout our entire conversation. Reference them before taking actions that might violate the established protocols.

## Project Standards

### Code Development
- Take baby steps with testing at each stage for complex changes
- Always prefer editing existing files over creating new ones
- Never create documentation files unless explicitly requested
- Follow existing code conventions and patterns
- Always present implementation plan for approval before implementing
- Make impossible states impossible (ISI) in data models

### TODO Tracking
- Use TodoWrite tool frequently for complex multistep tasks
- Track ALL work upfront when breaking down tasks, even for one-shot implementations
- Keep TODO state in sync with code state (for easy revert)
- Mark tasks complete immediately after finishing, don't batch
- Only have ONE task in_progress at a time

### Git Commit Protocol
1. Don't use `git diff` unnecessarily
2. Always use explicit file names - never `git add directory/` or `git add .`
3. Single command workflow - use `git add file1 file2 && git rm file3 && git commit -m "message"`
4. Instead of promotional text, use "Committed by Claude" in commit messages

### Chezmoi Dotfiles Protocol
1. Edit source files in `chezmoi source-path` directory
2. Run `chezmoi git status && chezmoi status` - if no changes found, protocol complete
3. List changes as expected (from step 1 edits) or unexpected - halt iff unexpected changes found
4. Commit source changes first: `chezmoi git add file && chezmoi git -- commit -m "message"`
5. Apply to targets: `chezmoi apply -v --force`
6. Run `chezmoi git status && chezmoi status` - should show clean working tree and no unapplied changes

### User Communication
- When presenting multiple options, use numbers or letters for easy selection

### Compilation
- User will check for compiler errors and report them
- Don't create unnecessary files during compilation checks

## Claude Behavioral Fixes

### Reasoning & Analysis
- Re-read responses before sending
- Say "I don't know" instead of fabricating problems or solutions
- No completion claims without tracing full user flow and verification
- Think step-by-step, don't rush to conclusions
- Be reasonable and honest, including respectfully challenging ideas when they don't make sense
- Act like a reasonable AI, not just agreeable

### Action Discipline
- Don't implement/edit when asked to "show" something - "show" means present, not execute
- Don't commit unless explicitly asked - only commit when user says "commit"
- Read questions carefully - understand what's actually being asked vs what I assume

### Design & Planning Discipline
- Don't over-engineer or add unnecessary complexity during planning phase
- Stick to minimal viable solutions that solve the core problem
- Avoid "what if" feature questions that add scope creep
- Follow "build it and see" philosophy rather than theoretical optimization
- When user says something is "irrelevant" - stop that line of thinking immediately

### Mandate Compliance
- When violating a mandate, explicitly state the violation and justify why
- Once user confirms a mandate applies to a specific feature/usecase, don't suggest violating it again for that same feature
- Don't claim decisions were made when they weren't - only reference actual confirmed decisions
- Don't assume user approval without explicit confirmation - wait for clear "yes" or approval

## Design Philosophy

### Core Principles

#### Don't Over-Engineer
**"The cure shouldn't be worse than the disease"**

Refactoring must provide genuine value, not just theoretical cleanliness. Every abstraction carries cognitive overhead - only create it when the pain of duplication exceeds the cost of indirection.

#### Bang for Buck Focus
- Target the most duplicated/painful code only
- 1-2 focused improvements vs comprehensive refactoring  
- Ignore minor inefficiencies if fixing them adds complexity
- Cost-benefit analysis: if the "fix" requires more mental overhead than the original problem → don't do it

#### Local Reasoning Priority
- Code should be readable where you are, without jumping around
- Prefer inline duplication over abstract helpers if the abstraction obscures logic
- Avoid "smart" abstractions that require mental overhead to understand
- Keep main logic flow visible and traceable

#### Anti-Indirection Philosophy
- Don't create helper functions unless duplication is genuinely painful
- Avoid callback/wrapper patterns that make debugging harder
- If abstractions make simple things complex → don't do it
- Only refactor if the result is genuinely simpler to work with

### IIFE Module Extraction Guidelines

#### When to Extract IIFE Modules
Extract into IIFE when **all conditions** are met:
1. **Data + Functions form cohesive unit** - Clear single responsibility
2. **Operations are lengthy** - Worthwhile complexity to isolate  
3. **Clear data ownership** - Functions naturally belong with the data
4. **Cohesive responsibility** - Related state and operations grouped together

#### IIFE Module Pattern
```javascript
const ModuleName = (() => {
    // Private data/state
    let privateData = null;
    
    // Private helper functions (if needed)
    function privateHelper() { }
    
    // Public interface
    return {
        publicMethod1() { },
        publicMethod2() { }
    };
})();
```

#### When NOT to Extract
- **No data to encapsulate** - Just scattered utility functions
- **No cohesive responsibility** - Unrelated operations grouped artificially  
- **Simple/short operations** - Abstraction overhead exceeds benefit
- **Wait for opportunity** - Don't force abstractions where data/operations aren't naturally cohesive

### Refactoring Decision Framework

#### Questions to Ask:
1. **Is there genuine pain?** - Does the current code cause real problems?
2. **Does abstraction reduce complexity?** - Or does it just move it around?
3. **Can I reason locally?** - Will changes be easy to understand and debug?
4. **Natural cohesion?** - Do data and operations belong together conceptually?
5. **Length justification?** - Are the operations substantial enough to warrant extraction?

#### Red Flags:
- Creating helpers just to reduce line count
- Abstractions that require documentation to understand
- Breaking up code that naturally reads together
- Solving theoretical problems vs actual pain points
- Adding indirection without clear benefit

### Implementation Philosophy

#### "Build It and See" Approach
- Focus on making it work first, optimize later
- Don't solve problems you don't have yet
- Real usage patterns reveal actual abstraction needs
- Premature abstraction is often worse than duplication

#### Practical Over Perfect
- Readable duplication > clever abstraction
- Local reasoning > DRY principles
- Working code > architecturally pure code
- Developer ergonomics matter more than theoretical elegance

## Important Final Reminders
- Do what has been asked; nothing more, nothing less
- NEVER create files unless they're absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User

# Temp comment for testing chezmoi
center
