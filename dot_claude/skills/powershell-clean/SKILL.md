---
name: powershell-clean
description: Use this skill whenever executing PowerShell or pwsh commands via Bash. This includes any Bash tool call containing pwsh, powershell, or running .ps1 scripts. Triggers on any PowerShell execution — even simple one-liners. Ensures clean output with no ANSI escape sequences, no encoding errors, no progress bar artifacts, and no popup windows.
user-invocable: false
disable-model-invocation: false
---

# Clean PowerShell Execution

When running PowerShell commands through Bash, raw invocations produce broken output — ANSI escape codes, progress bar artifacts, encoding garbage, and popup windows. Every pwsh call must use the patterns below.

## Required invocation pattern

Always wrap PowerShell commands like this:

```bash
pwsh -NoProfile -NonInteractive -NoLogo -Command '
  $PSStyle.OutputRendering = "PlainText"
  $ProgressPreference = "SilentlyContinue"
  $env:NO_COLOR = "1"
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

  # your actual command(s) here
'
```

Every flag and preamble line serves a purpose:

- `-NoProfile` — skips profile scripts that may print output or change settings
- `-NonInteractive` — prevents prompts and popup windows
- `-NoLogo` — suppresses the startup banner
- `$PSStyle.OutputRendering = "PlainText"` — disables ANSI escape sequences in output
- `$ProgressPreference = "SilentlyContinue"` — suppresses progress bars (Invoke-WebRequest, Install-Module, etc.)
- `$env:NO_COLOR = "1"` — signals no-color to tools that respect the NO_COLOR convention
- `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` — prevents encoding corruption

## Quoting rules

Quoting is the primary source of syntax errors when embedding PowerShell in Bash. Follow these rules strictly:

1. Use **single quotes** for the outer Bash wrapper: `pwsh -Command '...'`
2. Use **double quotes** inside for PowerShell strings: `"PlainText"`, `"SilentlyContinue"`
3. If the PowerShell code itself needs single quotes, escape them as `'\''` (end bash string, literal quote, resume bash string):
   ```bash
   pwsh -NoProfile -NonInteractive -NoLogo -Command '
     $PSStyle.OutputRendering = "PlainText"
     $ProgressPreference = "SilentlyContinue"
     $env:NO_COLOR = "1"
     [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

     Get-Content '\''C:\path\to\file.txt'\''
   '
   ```
4. Never use `$()` inside single-quoted Bash strings — it will not expand, which is what you want. PowerShell variables like `$PSStyle` pass through safely.
5. For complex scripts with heavy quoting, write to a temp .ps1 file first, then invoke it:
   ```bash
   pwsh -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File /tmp/script.ps1
   ```
   When using `-File`, add the preamble lines at the top of the .ps1 script itself.

## Formatting output

Avoid cmdlets that produce formatted objects with ANSI decoration:

- Prefer `Select-Object` over `Format-Table` or `Format-List`
- Prefer `ConvertTo-Json` or `ConvertTo-Csv` for structured data
- Pipe to `Out-String -Width 200` if you need wide tabular output without truncation

## Running .ps1 scripts

```bash
pwsh -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File ./script.ps1
```

If you do not control the script contents, prepend the preamble by wrapping:

```bash
pwsh -NoProfile -NonInteractive -NoLogo -Command '
  $PSStyle.OutputRendering = "PlainText"
  $ProgressPreference = "SilentlyContinue"
  $env:NO_COLOR = "1"
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

  & "./script.ps1"
'
```
