# Dotfiles

My Windows development environment, managed with [chezmoi](https://www.chezmoi.io/).

## Setup

```bash
chezmoi init https://github.com/jigargosar/dotfiles.git
chezmoi apply
```

## Dependencies

- **PowerShell 7** (`pwsh`) — the statusline and profile assume it.
- **BurntToast** — context-usage toasts from the statusline. Without it the statusline
  still runs; it warns once and skips the toast.

  ```powershell
  Install-Module -Name BurntToast -Scope CurrentUser
  ```
