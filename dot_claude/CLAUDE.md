# Claude Instructions

### General Section
1. Always present implementation plan for approval before implementing
2. When presenting multiple options/choices to user, ALWAYS use numbers or letters prefixes, with proper formatting and indentation.

### Code Development
1. Always prefer editing existing files over creating new ones
2. Make impossible states impossible (ISI) when planning data models

### Elm-Specific
  - Always check compilation with `elm make <file> --output=NUL`
  - Never use `--output=elm.js` or similar - we only want to verify compilation, not create artifacts

# Prettier config
* When user asks to install prettier, and its not installed, install using inferred package manager, as a dev dependency
* If package manager cannot be inferred, use pnpm.
* Ensure that prettier config exists in package.json, if not found use following as default. if found don't modify it.
```json
  "prettier": {
    "semi": false,
    "singleQuote": true,
    "trailingComma": "all",
    "endOfLine": "lf"
  },
```

# Other Instructions 
- Don't use cd command or reference file from its full path. Use file name relative to current project workspace. 
- by symmetry I meant, keep child elements similar level of abstraction, prefer extraction of methods.
- if I rejected 2-3 of your solutions, you should ask:
  "It seems like you have a specific approach in mind. Could you share the solution you might be thinking of? That would be more efficient than me continuing to guess."
- don't use cd path when files are relative to current workspace/project, when executing any command
- In general, use file names relative to current project workspace, not absolute paths.
- when I ask for check diff or analyze diff, or just diff, use git diff and analyze all changes. don't skip any change from analysis. No false positives. Also check for any bugs introduced.
- always prefer type aliases even if their backing type is basic, i.e Set(Int,Int) bad. Set(RowIdx, ColIdx) good. type alias RowIdx = Int....
- Never suggest callers use internal implementation details (Set.empty, Dict.empty, raw tuples, etc.) - they must use the module's exposed functions and types only, and type alias should be used instead of generic data types. Ideally we should use custom types, but thats not always practical.
- always focus on redability as opposed to performance. Warn only about exponential increases.
- I want simpler solutions, across functions. blindly improving single function without understanding its context leads to bad results.
- for simple renaming, use simple tools like grep/sed etc. dont waste tokens unless refactoring is tricky.
- When a module uses type alias for its model instead of a custom type, clients must treat it as opaque, and the module must provide an API as if that type were opaque - type aliases are an implementation choice, encapsulation is a design principle that applies regardless.
- Abstractions and precomputed configs, are not for optimization, they are for decoupling, encaptulation. Unless explecityfied we dont care about speed optimization. But only about rediability and comlexity that stems from lack thereof.
- for every response dont be super verbose, communicate in concise but complete form.
- dont worry about : memory-heavy for large states. Unless its exponentially costly. Simplicity wins by default, unless specified.
- dont run interactive commands, there is no way you can read its output.
- rather than assuming that package manager is npm, let default be pnpm. package managers can be infered from lockfile extension.
- don't keep jumping to implementation without thinking through the design with me first.
- Default design Must always focus on Single Source of Truth.
- When presenting solutions, Never give silly and obviously wrong answers.
- When providing solutions Always present recommended solution.
- ignore reference directory, unless I explictly ask to look into it
- dont add any claude specific promotions to git commit messages, just use "Commited by Claude" instead
- `chezmoi git` commands options need to be specified by using double hypen, otherwise chezmoi will pick it up and cause errors
- when I ask to "add todo:" just add it, no need to start discussion about it. You need to focus on current discussion, if any.
- when processing commit request, if its required to run multiple commands (like diff status etc.), prefer running them `&&` if it makes sense.
- never swallow/rethrow same exceptions, let them propogate to top level, so as to fail fast. Unless its needed for logical flow, then handle the case properly
- dont add obvious comments, where it is clear from identifier name, the intended purpose
- When user asks to publish a package: discuss and recommend semver level (patch/minor/major), run npm version [level] && git push --tags; check for CI/CD automation and ask user if they want to run npm publish