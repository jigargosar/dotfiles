---
name: library-react
description: |
  React component patterns and conventions.
  TRIGGER when editing .tsx/.jsx files that import from 'react',
  or when creating new React components.
user-invocable: false
allowed-tools: Read, Grep, Glob
---

# React Conventions

## Hooks

- A single hook inline in a component is fine
- When 2+ hooks work together for the same concern, combine them into a custom hook and extract
