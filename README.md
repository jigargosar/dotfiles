# Dotfiles

My Windows development environment, managed with [chezmoi](https://www.chezmoi.io/).

## What's Here

### Claude Code

I use Claude Code extensively and have built up a set of configurations over time to make it work well for how I think about code.

`CLAUDE.md` defines how Claude should behave — coding standards I care about (readability over cleverness, fail-fast error handling, tell-don't-ask), response style (terse by default, no unsolicited commentary), and workflow rules (always plan before implementing, never revert without asking).

There are 15 skills that automate things I kept doing manually:

- `code-audit` runs two review agents in parallel (one for standards violations, one for bugs) and cross-checks the results
- `chezmoi-sync` handles the fiddly add/commit/push cycle for dotfile changes with safeguards against accidental data loss
- `vite-ts-init` scaffolds a Vite + TypeScript + Tailwind v4 project the way I like it set up
- Others handle language conventions (Elm, TypeScript), project boards, package publishing, and various small things

The statusline is a PowerShell script that shows git branch/dirty/ahead-behind status, the active model, and context window usage — color-coded so I can tell at a glance when context is getting full.

### PowerShell

My profile prioritizes startup speed. Completions for chezmoi, zoxide, and scoop are loaded lazily on first idle and cached to disk so they don't shell out every time. The prompt shows the current path with git status. There's a one-time telemetry line on startup that shows load time so I notice if something regresses.

### Neovim

A fairly standard lazy.nvim setup. Mason-managed LSP servers for Lua, Elm, and JSON. Telescope for fuzzy finding with project root detection. A small custom buffer picker for switching buffers by number.

### Rainmeter

A world clock widget I made — shows two configurable timezones on a frosted dark card. Cities are switchable via right-click.

## Setup

```bash
chezmoi init https://github.com/jigargosar/dotfiles.git
chezmoi apply
```

The Claude Code statusline needs manual setup since `~/.claude/settings.json` isn't tracked (Claude Code modifies it at runtime). Add this after applying:

```json
{
  "statusLine": {
    "type": "command",
    "command": "pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ~/statusline.ps1"
  }
}
```

## Structure

```
dot_claude/                         # ~/.claude/
  CLAUDE.md                         #   Coding philosophy and behavioral rules
  rules/                            #   Conventions for bash, code, communication, git
  skills/                           #   15 workflow definitions
  commands/                         #   Slash commands
  statusline.ps1                    #   Git + context statusline

dot_gitconfig                       # ~/.gitconfig

AppData/Local/nvim/                 # Neovim
  init.vim                          #   Entry point (lazy.nvim bootstrap)
  lua/                              #   Plugins, keymaps, buffer picker

readonly_Documents/PowerShell/      # PowerShell profile
readonly_Documents/Rainmeter/       # WorldClock skin
```
