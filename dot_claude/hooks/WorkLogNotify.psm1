# WorkLogNotify.psm1
# Self-contained module: fires a Windows toast reminding me to log what I'm
# working on, once per NudgeAfterMinutes of *active* work.
#
# The statusline is the clock. A render means I am actively in a Claude
# session, so no background poller and no OS idle detection are needed.
# Time between two renders counts as work only if the gap is small; a large
# gap means I stepped away, and adds nothing.
#
# State is GLOBAL, not per-session (unlike ContextNotify.psm1, which keys its
# state file by SessionId): any Claude session counts toward the same clock,
# so two open windows share one timer instead of each running their own.
#
# DEPENDENCY: BurntToast, same as ContextNotify.psm1. See that file for why
# BurntToast rather than raw WinRT calls under pwsh 7.

$script:NudgeAfterMinutes     = 45   # active work between nudges
$script:BreakThresholdMinutes = 20   # gap above this counts as a break

$script:StateFile = "$env:TEMP\claude-worklog\state.json"

function Get-WorkLogState {
    # First run (or a fresh clock, see below): start now rather than assuming
    # prior work, so the first nudge is one that was actually earned.
    $fresh = [PSCustomObject]@{
        lastRender    = [int64](Get-Date -UFormat %s)
        activeSeconds = 0
    }

    if (-not (Test-Path $script:StateFile)) {
        return $fresh
    }

    # An empty/whitespace state file (crash mid-write, disk full, a 0-byte
    # file left by an interrupted Set-Content, etc.) falls back to a fresh
    # clock instead of throwing. Losing the current tally is harmless -- the
    # nudge just restarts its countdown. Genuinely malformed JSON (non-empty
    # but unparseable) still throws so corruption is visible and fixable.
    $raw = Get-Content $script:StateFile -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $fresh
    }
    $state = $raw | ConvertFrom-Json
    if ($null -eq $state -or $null -eq $state.lastRender -or $null -eq $state.activeSeconds) {
        return $fresh
    }
    $state
}

function Send-WorkLogToast {
    if (-not (Get-Module -ListAvailable -Name BurntToast)) {
        Write-Warning "WorkLogNotify: BurntToast module not found -- install with: Install-Module -Name BurntToast -Scope CurrentUser"
        return
    }
    Import-Module BurntToast -ErrorAction SilentlyContinue

    # -Header renders at the top and groups these in Action Center; the first
    # -Text string is the toast's own title.
    $header = New-BTHeader -Id "claude-worklog" -Title "Claude Code"

    New-BurntToastNotification -Text "Work log", "What are you working on? ($script:NudgeAfterMinutes min since the last entry)" `
        -Header $header `
        -UniqueIdentifier "claude-worklog"   # same ID = replaces old toast, never stacks
}

# Advances the timer for this render and fires the nudge when due.
# Returns the current activeSeconds so the statusline can render a countdown.
function Update-WorkLogTimer {
    New-Item -ItemType Directory -Force -Path (Split-Path $script:StateFile) | Out-Null

    $state = Get-WorkLogState
    $now   = [int64](Get-Date -UFormat %s)
    $gap   = $now - [int64]$state.lastRender

    # A gap within the break threshold is continuous work — thinking time,
    # reading output and long-running tools all count. A larger gap means I
    # was away: it adds nothing, but the banked total is kept so returning
    # from a break resumes where the clock stopped.
    if ($gap -ge 0 -and $gap -le ($script:BreakThresholdMinutes * 60)) {
        $state.activeSeconds = [int64]$state.activeSeconds + $gap
    }
    $state.lastRender = $now

    if ([int64]$state.activeSeconds -ge ($script:NudgeAfterMinutes * 60)) {
        Send-WorkLogToast
        $state.activeSeconds = 0
    }

    $state | ConvertTo-Json | Set-Content $script:StateFile
    [int64]$state.activeSeconds
}

# Exposed so statusline.ps1 can colour the counter without duplicating the
# threshold value.
function Get-WorkLogNudgeAfterMinutes { $script:NudgeAfterMinutes }

Export-ModuleMember -Function Update-WorkLogTimer, Get-WorkLogNudgeAfterMinutes
