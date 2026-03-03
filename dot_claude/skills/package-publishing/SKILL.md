---
name: package-publishing
description: npm package publishing workflow. TRIGGER when user asks to publish, version, or release a package.
user-invocable: false
disable-model-invocation: false
---

- When user asks to publish: discuss and recommend semver level (patch/minor/major)
- Never assume what semver to use, always double check
- Run `npm version [level] && git push --tags`
- NEVER run `npm publish`, unless explicitly asked
