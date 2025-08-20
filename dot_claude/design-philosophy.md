# Design Philosophy

## Core Principles

### Don't Over-Engineer
**"The cure shouldn't be worse than the disease"**

Refactoring must provide genuine value, not just theoretical cleanliness. Every abstraction carries cognitive overhead - only create it when the pain of duplication exceeds the cost of indirection.

### Bang for Buck Focus
- Target the most duplicated/painful code only
- 1-2 focused improvements vs comprehensive refactoring  
- Ignore minor inefficiencies if fixing them adds complexity
- Cost-benefit analysis: if the "fix" requires more mental overhead than the original problem → don't do it

### Local Reasoning Priority
- Code should be readable where you are, without jumping around
- Prefer inline duplication over abstract helpers if the abstraction obscures logic
- Avoid "smart" abstractions that require mental overhead to understand
- Keep main logic flow visible and traceable

### Anti-Indirection Philosophy
- Don't create helper functions unless duplication is genuinely painful
- Avoid callback/wrapper patterns that make debugging harder
- If abstractions make simple things complex → don't do it
- Only refactor if the result is genuinely simpler to work with

## IIFE Module Extraction Guidelines

### When to Extract IIFE Modules
Extract into IIFE when **all conditions** are met:
1. **Data + Functions form cohesive unit** - Clear single responsibility
2. **Operations are lengthy** - Worthwhile complexity to isolate  
3. **Clear data ownership** - Functions naturally belong with the data
4. **Cohesive responsibility** - Related state and operations grouped together

### IIFE Module Pattern
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

### When NOT to Extract
- **No data to encapsulate** - Just scattered utility functions
- **No cohesive responsibility** - Unrelated operations grouped artificially  
- **Simple/short operations** - Abstraction overhead exceeds benefit
- **Wait for opportunity** - Don't force abstractions where data/operations aren't naturally cohesive

## Refactoring Decision Framework

### Questions to Ask:
1. **Is there genuine pain?** - Does the current code cause real problems?
2. **Does abstraction reduce complexity?** - Or does it just move it around?
3. **Can I reason locally?** - Will changes be easy to understand and debug?
4. **Natural cohesion?** - Do data and operations belong together conceptually?
5. **Length justification?** - Are the operations substantial enough to warrant extraction?

### Red Flags:
- Creating helpers just to reduce line count
- Abstractions that require documentation to understand
- Breaking up code that naturally reads together
- Solving theoretical problems vs actual pain points
- Adding indirection without clear benefit

## Implementation Philosophy

### "Build It and See" Approach
- Focus on making it work first, optimize later
- Don't solve problems you don't have yet
- Real usage patterns reveal actual abstraction needs
- Premature abstraction is often worse than duplication

### Practical Over Perfect
- Readable duplication > clever abstraction
- Local reasoning > DRY principles
- Working code > architecturally pure code
- Developer ergonomics matter more than theoretical elegance