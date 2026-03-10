---
name: fix-chrome-connection
description: Diagnose and fix Claude-in-Chrome browser extension connection failures on Windows. Use when encountering "Browser extension is not connected" errors, MCP browser tools stop working, or Claude Code CLI cannot reach the Chrome extension.
user-invocable: true
disable-model-invocation: false
---

# Fix Claude-in-Chrome Connection

## Root Cause

On Windows, Claude-in-Chrome uses a named pipe `\\.\pipe\claude-mcp-browser-bridge-{username}` for communication. Stale `claude.exe` processes from previous sessions hold this pipe open, blocking new connections. The specific culprit is the `--chrome-native-host` process spawned by Chrome via `chrome-native-host.bat`.

## Shell Compatibility

Use `powershell.exe -Command "..."` and `taskkill` for process inspection and killing. `wmic` does not work.

## Safety

**Do NOT broaden search filters.** If the exact commands below find nothing, skip to the Fallback section. Never match on broad terms like `mcp`, `browser`, or `chrome` — this will kill your own MCP server connections and cascade into errors.

## Step 1: List claude.exe processes

```
powershell.exe -Command "Get-CimInstance Win32_Process -Filter \"name='claude.exe'\" | Select ProcessId,CommandLine | Format-List"
```

Look for a process with `--chrome-native-host` in its CommandLine. This is the stale pipe holder. It is safe to kill — Claude Code CLI is never this process.

Note: CommandLine may appear blank for some processes due to Windows access restrictions. This is normal.

## Step 2: Kill the stale native host

If you found a PID with `--chrome-native-host`:

```
taskkill /PID <pid> /F
```

If CommandLine was blank for all processes but there are suspicious `claude.exe` entries you don't recognize, skip to Fallback.

## Step 3: Verify

Re-run the powershell command from Step 1. The `--chrome-native-host` process should be gone.

Then retry the browser connection.

## Fallback: If Step 1 finds nothing or CommandLine is blank

The native host process may not be visible. In this case:

1. **Close Chrome completely** (all windows — check system tray too). This kills all Chrome child processes including the native host.
2. **Reopen Chrome.**
3. **Retry the CLI connection.**

This is the most reliable fix when process inspection fails.

## Still broken after fallback?

1. Open Chrome → Extensions → Claude → toggle off, then on
2. If extension shows `_metadata` corruption error in chrome://extensions, fully uninstall and reinstall from Chrome Web Store
3. If native host bat crashes (Bun panic), reinstalling the extension resets it
4. If all else fails, restart the Claude Code CLI session entirely

## Process Flag Reference

| Flag | Role | Safe to kill? |
|---|---|---|
| `--chrome-native-host` | Native messaging host, owns the named pipe | YES — always safe |
| `--claude-in-chrome-mcp` | MCP server for browser tools | YES but only if stale |
| `--chrome` | Main CLI session using browser tools | NO — this is your active session |

## Reference

- Pipe path: `\\.\pipe\claude-mcp-browser-bridge-jigar`
- Native host script: `~\.claude\chrome\chrome-native-host.bat`
- GitHub issue: https://github.com/anthropics/claude-code/issues/24593
