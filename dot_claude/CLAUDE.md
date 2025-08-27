# Claude Instructions

IMPORTANT: Read, internalize, and consistently follow these guidelines throughout our entire conversation. Reference them before taking actions that might violate the established protocols.

## Project Standards

### Code Development
1. Take baby steps for complex changes by breaking planning into multiple steps/TODO items
2. Execute tiny single-step changes (like simple refactoring, single-line edits, or multiple tiny TODO items) in one shot without baby steps
3. Always prefer editing existing files over creating new ones
4. Never create documentation files unless explicitly requested
5. Follow existing code conventions and patterns
6. Always present implementation plan for approval before implementing
7. Make impossible states impossible (ISI) in data models

### TODO Tracking
1. Track ALL work upfront when breaking down tasks, even for one-shot implementations
2. Always include numbers in content field: "1. Task description"
3. Only display TODOs via TodoWrite tool output - never create separate manual lists

### Extended Git Commit Protocol
These extensions enhance the default git commit workflow:
1. Don't use `git diff` unnecessarily when changes are obvious
2. Always use explicit file names - never use `git add directory/` or `git add .` as shortcuts
3. Single command workflow - use `git add file1 file2 && git mv file3 file4 && git rm file5 && git commit -m "message"`
4. Instead of promotional text, use "Committed by Claude" in commit messages

### Chezmoi Dotfiles Protocol
1. Edit source files in `chezmoi source-path` directory
2. Run `chezmoi git status && chezmoi status` - if no changes found, protocol complete
3. List changes as expected (from step 1 edits) or unexpected - halt iff unexpected changes found
4. Commit source changes first: `chezmoi git add file && chezmoi git -- commit -m "message"`
5. Apply to targets: `chezmoi apply --force`
6. Run `chezmoi git status && chezmoi status` - should show clean working tree and no unapplied changes
7. Push changes: `chezmoi git -- push`

### User Communication
1. When presenting multiple options, use numbers or letters for easy selection

### Compilation
1. User will check for compiler errors and report them
2. Don't create unnecessary files during compilation checks

## Claude Behavioral Fixes

### Reasoning & Analysis
1. Re-read responses before sending
2. Say "I don't know" instead of fabricating problems or solutions
3. No completion claims without tracing full user flow and verification
4. Think step-by-step, don't rush to conclusions
5. Be reasonable and honest, including respectfully challenging ideas when they don't make sense
6. Act like a reasonable AI, not just agreeable

### Action Discipline
1. Don't implement/edit when asked to "show" something - "show" means present, not execute
2. Don't commit unless explicitly asked - only commit when user says "commit"
3. Read questions carefully - understand what's actually being asked vs what I assume

### Design & Planning Discipline
1. Don't over-engineer or add unnecessary complexity during planning phase
2. Stick to minimal viable solutions that solve the core problem
3. Avoid "what if" feature questions that add scope creep
4. Follow "build it and see" philosophy rather than theoretical optimization
5. When user says something is "irrelevant" - stop that line of thinking immediately

### Mandate Compliance
1. When violating a mandate, explicitly state the violation and justify why
2. Once user confirms a mandate applies to a specific feature/usecase, don't suggest violating it again for that same feature
3. Don't claim decisions were made when they weren't - only reference actual confirmed decisions
4. Don't assume user approval without explicit confirmation - wait for clear "yes" or approval

## Design Philosophy

### Core Principles

#### Don't Over-Engineer
**"The cure shouldn't be worse than the disease"**

Refactoring must provide genuine value, not just theoretical cleanliness. Every abstraction carries cognitive overhead - only create it when the pain of duplication exceeds the cost of indirection.

#### Bang for Buck Focus
1. Target the most duplicated/painful code only
2. 1-2 focused improvements vs comprehensive refactoring  
3. Ignore minor inefficiencies if fixing them adds complexity
4. Cost-benefit analysis: if the "fix" requires more mental overhead than the original problem → don't do it

#### Local Reasoning Priority
1. Code should be readable where you are, without jumping around
2. Prefer inline duplication over abstract helpers if the abstraction obscures logic
3. Avoid "smart" abstractions that require mental overhead to understand
4. Keep main logic flow visible and traceable

#### Anti-Indirection Philosophy
1. Don't create helper functions unless duplication is genuinely painful
2. Avoid callback/wrapper patterns that make debugging harder
3. If abstractions make simple things complex → don't do it
4. Only refactor if the result is genuinely simpler to work with

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
1. **No data to encapsulate** - Just scattered utility functions
2. **No cohesive responsibility** - Unrelated operations grouped artificially  
3. **Simple/short operations** - Abstraction overhead exceeds benefit
4. **Wait for opportunity** - Don't force abstractions where data/operations aren't naturally cohesive

### Refactoring Decision Framework

#### Questions to Ask:
1. **Is there genuine pain?** - Does the current code cause real problems?
2. **Does abstraction reduce complexity?** - Or does it just move it around?
3. **Can I reason locally?** - Will changes be easy to understand and debug?
4. **Natural cohesion?** - Do data and operations belong together conceptually?
5. **Length justification?** - Are the operations substantial enough to warrant extraction?

#### Red Flags:
1. Creating helpers just to reduce line count
2. Abstractions that require documentation to understand
3. Breaking up code that naturally reads together
4. Solving theoretical problems vs actual pain points
5. Adding indirection without clear benefit

### Implementation Philosophy

#### "Build It and See" Approach
1. Focus on making it work first, optimize later
2. Don't solve problems you don't have yet
3. Real usage patterns reveal actual abstraction needs
4. Premature abstraction is often worse than duplication

#### Practical Over Perfect
1. Readable duplication > clever abstraction
2. Local reasoning > DRY principles
3. Working code > architecturally pure code
4. Developer ergonomics matter more than theoretical elegance

## Important Final Reminders
1. Do what has been asked; nothing more, nothing less
2. NEVER create files unless they're absolutely necessary for achieving your goal
3. ALWAYS prefer editing an existing file to creating a new one
4. NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User

# Temp comment for testing chezmoi
center
