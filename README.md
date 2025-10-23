# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Contents

- `.gitconfig` - Git configuration
- `.claude/CLAUDE.md` - Claude Code global instructions
- `.claude/statusline.ps1` - Claude Code statusline script
- `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` - PowerShell profile
- `notes/` - Personal notes

## Setup

### Initial Installation

```bash
# Install chezmoi and apply dotfiles
chezmoi init https://github.com/jigargosar/dotfiles.git
chezmoi apply
```

### Claude Code Configuration

The statusline script is managed at `.claude/statusline.ps1`.

After restoring dotfiles, manually add this to `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:\\Users\\jigar\\.claude\\statusline.ps1\""
  }
}
```

**Note:** `settings.json` is not tracked by chezmoi because Claude Code modifies it at runtime (thinking mode, permissions, etc.).

## PowerShell Profile

The PowerShell profile uses dynamic completion initialization for:
- **zoxide** - Smarter cd command
- **chezmoi** - Dotfile manager
- **scoop** - Package manager (via scoop-completion module)

Completions are generated at shell startup to stay current with tool versions.

## Updating Dotfiles

When you modify tracked files (CLAUDE.md, notes, etc.), update the repository:

```bash
chezmoi re-add           # Update chezmoi with current file versions
chezmoi git -- add -A    # Stage changes
chezmoi git -- commit -m "chore: update dotfiles"
chezmoi git -- push      # Push to remote
```

**Tip:** Create a PowerShell function to automate this workflow (see todo).
