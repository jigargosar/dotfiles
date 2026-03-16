---
name: vite-ts-init
description: Initialize or update a Vite + TypeScript + Tailwind v4 + pnpm project. Works on new and existing projects. Use when user runs /vite-ts-init.
user-invocable: true
---

# vite-ts-init

Initialize or update Vite + TypeScript + Tailwind v4 + pnpm in the current directory.

## Approach

Run all steps silently. Only pause before destructive actions (e.g. overwriting an existing file).

If existing project detected, recommend and present options, and offer to diff and propose changes.

## Steps

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

If `package.json` already exists, ask before overwriting.

### 2. Install dependencies

```bash
pnpm add -D vite typescript prettier tailwindcss @tailwindcss/vite @vitejs/plugin-basic-ssl
```

After install, if pnpm warns about ignored build scripts, prompt the user to run `pnpm approve-builds` before continuing.

### 3. Copy template files

Read each asset from `~/.claude/skills/vite-ts-init/assets/` and write to the project.
If a destination file already exists, ask before overwriting.

| Asset                  | Destination         |
|------------------------|---------------------|
| assets/index.html      | index.html          |
| assets/src/main.ts     | src/main.ts         |
| assets/src/global.css  | src/global.css      |
| assets/vite.config.ts  | vite.config.ts      |
| assets/tsconfig.json   | tsconfig.json       |
| assets/.prettierrc     | .prettierrc         |

After copying `index.html`, replace the `<title>App</title>` placeholder with the project name (same value used in `package.json`).

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
