# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

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
