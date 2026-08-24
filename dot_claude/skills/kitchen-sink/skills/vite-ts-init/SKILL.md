---
name: vite-ts-init
description: Initialize or update a Vite + TypeScript + Tailwind v4 + pnpm project. Works on new and existing projects.
user-invocable: true
model: inherit
allowed-tools: AskUserQuestion, Skill(git-init)
disable-model-invocation: false
---

## Approach

1. Run all steps silently. Pause only before destructive actions.
2. For each file write: read asset (apply any substitutions), read destination, diff.
3. If byte-identical: print one-line no-op note, move on. No AUQ.
4. If different: show diff, then AUQ before overwriting.
5. Append-only operations (e.g., `.gitignore` entries) don't require AUQ.

## Steps

### 0. Git init

AskUserQuestion: "Run `git-init` skill first?"
- "Yes" — Call `Skill(git-init)`, then continue.
- "Skip" — Continue.

### 1. package.json

Write `package.json`. Use `basename $(pwd)` for the name field.

```json
{
    "name": "<dir-name>",
    "private": true,
    "version": "0.0.0",
    "type": "module",
    "scripts": {
        "dev": "vite",
        "build": "vite build",
        "preview": "vite preview",
        "typecheck": "tsc --noEmit",
        "typecheck:watch": "tsc --noEmit --watch"
    }
}
```

### 2. Install dependencies

```bash
pnpm add -D vite typescript prettier tailwindcss @tailwindcss/vite vite-plugin-devtools-json
```

After install, if pnpm warns about ignored build scripts, prompt the user to run `pnpm approve-builds` before continuing.

### 3. Copy template files

Read each asset from `~/.claude/skills/vite-ts-init/assets/` and write to the project.

| Asset                  | Destination         |
|------------------------|---------------------|
| assets/index.html      | index.html          |
| assets/src/main.ts     | src/main.ts         |
| assets/src/global.css  | src/global.css      |
| assets/vite.config.ts  | vite.config.ts      |
| assets/tsconfig.json   | tsconfig.json       |
| assets/.prettierrc     | .prettierrc         |

When reading `index.html`, replace the `<title>App</title>` placeholder with the project name (same value used in `package.json`).

### 4. .gitignore

If `.gitignore` does not exist, read `assets/.gitignore` and write it.
If `.gitignore` exists, ensure these entries are present; append any that are missing:

```
.vscode
.idea
*.local.json
dist
.parcel-cache
*.tsbuildinfo
```
