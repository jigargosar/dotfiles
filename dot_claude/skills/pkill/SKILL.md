---
name: pkill
description: Find and kill processes by search term. Use when user wants to kill processes, stop services, or clean up running programs.
user-invocable: true
disable-model-invocation: false
argument-hint: <search-term>
allowed-tools: Bash(pwsh -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File */find-processes.ps1 *)
---

Understand the user's intent from "$ARGUMENTS" and extract the process search term.
Examples:
  "/pkill node" → search term: node
  "/pkill all devtools processes" → search term: devtools
  "/pkill kill anything related to chrome-devtools-mcp" → search term: chrome-devtools-mcp
  "/pkill clean up webstorm" → search term: webstorm

1. Run this exact command with the extracted search term:
   pwsh -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File ${CLAUDE_SKILL_DIR}/find-processes.ps1 <extracted-search-term>

   The YAML output is automatically displayed to the user. Do not re-render or summarize it.

2. If output says "No processes found", stop.

3. Tell the user: "What would you like to do? You can say things like: kill all, kill the webstorm ones, kill 1 and 3, etc."

4. Wait for the user's response. Parse their intent and identify the PIDs to kill.

5. Before killing, list what will be killed and ask for confirmation.

6. Kill each confirmed process by PID:
   pwsh -NoProfile -NonInteractive -NoLogo -Command '
     $PSStyle.OutputRendering = "PlainText"
     Stop-Process -Id <PID> -Force
   '
   Report success or failure for each.
