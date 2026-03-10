---
name: library-zustand
description: "Zustand state management patterns and conventions. TRIGGER when code imports from `zustand` or user is working with zustand stores."
user-invocable: false
---

# Zustand Conventions

## Store Access

- Never call `.getState()` from outside the store — consume state via hooks or selectors
- Inside store actions, use `get()` and `set()` directly (already provided by zustand)

## Actions

- Define actions inside the store using `set` and `get` — don't create external functions that reach into store internals
