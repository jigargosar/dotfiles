# ContextNotify.psm1
# Self-contained module: fires a Windows toast when Claude Code's context
# usage crosses a new threshold, once per threshold per session.
#
# DEPENDENCY (dev machine only): requires the BurntToast module.
#   Install once with:  Install-Module -Name BurntToast -Scope CurrentUser
#   Already installed on this machine as of this edit (v1.1.0).
#
# Why BurntToast instead of raw WinRT calls: this machine runs PowerShell 7
# (pwsh), and the native `[Type, Assembly, ContentType=WindowsRuntime]` toast
# syntax only works reliably under Windows PowerShell 5.1 -- under pwsh 7 it
# throws "Unable to find type ... ContentType=WindowsRuntime" (confirmed by
# testing on this machine). BurntToast ships a compiled helper instead of
# relying on that syntax, so it works correctly under both hosts.
# Depends only on its own parameters — no shared state with statusline.ps1,
# so it can be edited/extended without touching the main statusline file.

function Send-ContextThresholdAlert {
    param([int]$PctInt, [string]$SessionId, [string]$ContextLabel)

    # One state file PER SESSION so multiple windows on the same repo don't
    # overwrite each other's "already alerted at this level" tracking.
    $safeId    = ($SessionId -replace '[^a-zA-Z0-9\-]', '_')
    $stateFile = "$env:TEMP\claude-context-notify\state-$safeId.json"
    New-Item -ItemType Directory -Force -Path (Split-Path $stateFile) | Out-Null

    $thresholds = @(15, 20, 50, 80)   # edit these to change alert levels

    $state = [PSCustomObject]@{ lastThreshold = 0 }
    if (Test-Path $stateFile) {
        try { $state = Get-Content $stateFile -Raw | ConvertFrom-Json } catch {}
    }

    # Whenever pct drops below the last-alerted threshold (compaction, summarization, /clear
    # mid-session, etc.), recompute lastThreshold to match the tier pct is actually in now,
    # so any threshold between the new pct and the old lastThreshold can fire again on the way back up.
    if ($PctInt -lt $state.lastThreshold) {
        $passedNow = $thresholds | Where-Object { $PctInt -ge $_ } | Sort-Object -Descending | Select-Object -First 1
        $state.lastThreshold = if ($passedNow) { $passedNow } else { 0 }
    }

    $newThreshold = $thresholds | Where-Object { $PctInt -ge $_ -and $_ -gt $state.lastThreshold } |
                    Sort-Object -Descending | Select-Object -First 1

    if ($newThreshold) {
        # Dependency check: fail loudly (not silently) if BurntToast is missing,
        # since this is the one external piece this module relies on.
        if (-not (Get-Module -ListAvailable -Name BurntToast)) {
            Write-Warning "ContextNotify: BurntToast module not found -- install with: Install-Module -Name BurntToast -Scope CurrentUser"
            return
        }
        Import-Module BurntToast -ErrorAction SilentlyContinue

        New-BurntToastNotification -Text "Claude Code context — $ContextLabel", "Now at $PctInt% (passed $newThreshold%)" `
            -UniqueIdentifier "claude-context-$safeId"   # same ID = replaces old toast, never stacks

        $state.lastThreshold = $newThreshold
        $state | ConvertTo-Json | Set-Content $stateFile
    }
}

Export-ModuleMember -Function Send-ContextThresholdAlert
