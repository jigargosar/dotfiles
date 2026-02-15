---
name: fix-chrome-connection
description: Diagnose and fix Claude-in-Chrome browser extension connection failures on Windows. Use when encountering "Browser extension is not connected" errors, MCP browser tools stop working, or Claude Code CLI cannot reach the Chrome extension. Covers stale named pipe cleanup, process identification, and reconnection steps.
user-invocable: true
disable-model-invocation: false
---

# Fix Claude-in-Chrome Connection

## Root Cause

On Windows, Claude-in-Chrome uses a named pipe `\\.\pipe\claude-mcp-browser-bridge-{username}` for communication. Stale `claude.exe` processes from previous sessions (with flags `--chrome-native-host` or `--claude-in-chrome-mcp`) can hold this pipe open, blocking new connections.

## Diagnosis

```powershell
# 1. Check if the pipe exists
[System.IO.Directory]::GetFiles('\\.\pipe\') | Where-Object { $_ -match 'claude' }

# 2. Find chrome-related claude processes
Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'claude.exe' -and ($_.CommandLine -match 'chrome|mcp|browser') } | Select-Object ProcessId, CommandLine, CreationDate | Format-List
```

## Fix

1. Identify stale processes — look for `--chrome-native-host` and `--claude-in-chrome-mcp` processes with old start times (especially from previous days/sessions)
2. Kill only stale ones, preserving the current session:
   ```powershell
   taskkill /PID <stale_pid_1> /PID <stale_pid_2> /F
   ```
3. Verify pipe is released:
   ```powershell
   [System.IO.Directory]::GetFiles('\\.\pipe\') | Where-Object { $_ -match 'claude' }
   ```
4. Restart Chrome or the `claude --chrome` session to re-establish connection

## Key Process Flags

| Flag | Role |
|---|---|
| `--chrome-native-host` | Native messaging host — owns the named pipe |
| `--claude-in-chrome-mcp` | MCP server for browser tools |
| `--chrome` | Main CLI session using browser tools |

## Important

- **Never kill processes from the current active session** — compare start times
- The `--chrome-native-host` process is usually the one holding the pipe
- After killing stale processes, the current session should reconnect automatically or after a Chrome restart

## Reference

- GitHub issue: https://github.com/anthropics/claude-code/issues/24593
