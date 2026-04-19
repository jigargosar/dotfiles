---
name: open
description: Opens local files/directories in VSCode and URIs (http/https, mailto:, tel:, file:, vscode:, custom protocols) in their registered default Windows app via PowerShell Start-Process.
when_to_use: When the user asks to open a path or URI, or proactively whenever a clickable file path, line reference, or URI would otherwise be printed for the user to navigate to manually.
argument-hint: "[path-or-uri...]"
allowed-tools:
  - PowerShell(Start-Process *)
  - PowerShell(code *)
model: opus
effort: low
---

# open

All commands run fire-and-forget via the `PowerShell` tool with `run_in_background: true`. Never wait, never block, never surface exit codes. Failures are silent by design.

## Open URIs

`Start-Process` invokes Windows ShellExecute, routing each URI to its registered handler: http/https → browser, mailto: → mail client, vscode:// → VSCode, file: → default app, etc. Plain file paths also work (e.g. `Start-Process "C:/foo.pdf"` opens with default app), but for editable files prefer `code` (next section).

1. URL: `Start-Process "https://example.com"`
2. mailto: `Start-Process "mailto:foo@bar.com?subject=hi"`
3. Custom protocol: `Start-Process "vscode://file/C:/foo.ts:42"`
4. Multiple, mixed schemes in one call: `Start-Process "https://a.com"; Start-Process "mailto:x@y.com"; Start-Process "https://b.com"`

## Open in VSCode

1. File or directory: `code "C:/path"`
2. Jump to line: `code -g "C:/path/file.ts:42"`
3. Diff two files: `code --diff "C:/a.ts" "C:/b.ts"` — only when the user explicitly asks to diff. Otherwise open both files separately.
4. New window: `code -n "C:/path"`
5. Flags combine, e.g. `code -n -g "C:/path:10"`.
6. Multiple files in one window: `code "C:/a" "C:/b" "C:/c"`.
7. Multiple files with per-file flags: chain with `;`, e.g. `code "C:/a"; code -g "C:/b.ts:42"; code -n "C:/dir"`.

## Path normalization

Use forward slashes in paths passed to `Start-Process` and `code`, even on Windows. Both accept it and it avoids backslash-escaping in PowerShell strings.

## When to trigger

1. **Explicit** — "open X in vscode", "open this URL", "show me the diff", etc. The args may be one or many paths/URIs intermingled with prose or skill-invocation phrasing; extract all per the inference rule below. Always go through the Confirmation flow — no shortcuts.
2. **Proactive** — whenever a path, `file:line`, or URI would otherwise be printed for the user to click/copy, extract candidates and go through the Confirmation flow.

## Confirmation flow (hard rule — always confirm, no exceptions)

1. Infer candidate paths/URIs from BOTH the prior assistant response AND the current user prompt. They may appear intermingled with prose or skill-invocation phrasing (e.g., `/open check these out: foo.ts https://x.com mailto:a@b.com`) — extract every path/URI by pattern, regardless of position.
2. **1 candidate**: AUQ with options `["Open", "Skip"]`.
3. **2–3 candidates**: AUQ (single-select) with one option per candidate plus a final "All of above" option.
4. **≥4 candidates**: print a numbered serial list and wait for the user to say which numbers to open.
5. Open the chosen items in a single chained PowerShell call using `;`.

## Invocation

Always pass `run_in_background: true`:

```
PowerShell({
  command: 'Start-Process "https://example.com"',
  description: "Open URL in browser",
  run_in_background: true,
})
```
