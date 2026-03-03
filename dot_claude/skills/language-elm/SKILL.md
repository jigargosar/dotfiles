---
name: language-elm
description: Elm programming language conventions and package management. TRIGGER when project contains elm.json or user is working with .elm files.
user-invocable: false
disable-model-invocation: false
---

## Packages

- Package URL root: `https://package.elm-lang.org/packages/`
- Install: `echo "Y" | elm install <package-name>`
- Source root: `%APPDATA%\elm\0.19.1\packages\`

## Language Conventions

- Compilation MUST use `elm make src/Main.elm --output=NUL`.
- Use multiple class attributes, never do string concatenation.
- Never duplicate static classes, use multiple class attributes.
- Models MUST strictly follow `Make Invalid States Impossible` principle.
- Long class strings MUST be split into multiple class attributes.
- Avoid catch-all (`_`) case branches even if code duplicates across branches. Extract to helper when 3+ branches share identical body. Use catch-all only when 5+ branches share identical body.
- Expose types from imports rather than using qualified module names for types
