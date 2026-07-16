# Git-aware statusLine script for Claude Code
param()

try {

# Read JSON input from stdin
$inputText = $input | Out-String
$data = $inputText | ConvertFrom-Json

# Dump full stdin payload (pretty JSON) for inspection.
# Commented out by default now that debugging is done — uncomment this one line
# any time you need to inspect the raw fields Claude Code sends on stdin.
# $data | ConvertTo-Json -Depth 20 | Set-Content -Path "$env:USERPROFILE/.claude/statusline-dump.json" -Encoding utf8

$model = $data.model.display_name
$workspaceDir = $data.workspace.current_dir

# Truecolor palette (Neon Cyberpunk)
$teal     = "`e[38;2;140;255;200m"
$neonPink = "`e[38;2;255;50;120m"
$cyan     = "`e[38;2;80;200;255m"
$orange   = "`e[38;2;255;180;50m"
$lavender = "`e[38;5;183m"
$sage      = "`e[38;5;150m"
$yellow    = "`e[38;5;179m"
$hotRed    = "`e[38;5;203m"
$lightBlue = "`e[38;2;150;200;255m"
$dim       = "`e[38;5;240m"
$rst       = "`e[0m"

# Used-% gradient: green (0%) -> orange (mid) -> red (100%)
# Standard curve: green 0-20% (82), orange-yellow 20-75% (214→208), red 75-100% (202→196)
function Get-UsageColor([int]$p) {
    if ($p -le 20)      { "`e[38;5;82m"  }  # green
    elseif ($p -le 50)  { "`e[38;5;214m" }  # orange
    elseif ($p -le 75)  { "`e[38;5;208m" }  # dark orange
    elseif ($p -le 90)  { "`e[38;5;202m" }  # orange-red
    else                { "`e[38;5;196m" }  # hot red
}

# Tight curve (Opus, Sonnet 5): tight 0-20% window with distinct color stops (256-color ANSI)
#   0–5%:  ANSI 82  (bright green)
#   5–10%: ANSI 226 (yellow)
#  10–15%: ANSI 214 (dark yellow / orange)
#  15–20%: ANSI 202 (orange-red)
#    20%+: ANSI 196 (hot red)
function Get-UsageColorTight([int]$p) {
    if ($p -le 5)       { "`e[38;5;82m"  }  # bright green
    elseif ($p -le 10)  { "`e[38;5;226m" }  # yellow
    elseif ($p -le 15)  { "`e[38;5;214m" }  # dark yellow / orange
    elseif ($p -le 20)  { "`e[38;5;202m" }  # orange-red
    else                { "`e[38;5;196m" }  # hot red
}

# 10-block context bar — each block = 10% of context
function Get-ContextBar([int]$p, [scriptblock]$ColorFn) {
    $filled  = [math]::Min([math]::Floor($p / 10), 10)
    $bar = ""
    for ($i = 0; $i -lt 10; $i++) {
        $blockPct = ($i + 1) * 10  # percent this block represents
        $col = & $ColorFn $blockPct
        if ($i -lt $filled) {
            $bar += "${col}█${rst}"
        } else {
            $bar += "${dim}░${rst}"
        }
    }
    $bar
}

# Context-threshold toast alert lives in its own module (hooks\ContextNotify.psm1)
# so that logic can keep evolving without this file growing every time.
Import-Module "$PSScriptRoot\hooks\ContextNotify.psm1" -Force

Push-Location $workspaceDir

try {
    $parts = @()

    # === Git status ===
    git rev-parse --git-dir 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if (!$branch) { $branch = "?" }

        $stagedCount    = (git diff --cached --name-only 2>$null | Measure-Object).Count
        $unstagedCount  = (git diff --name-only 2>$null | Measure-Object).Count
        $untrackedCount = (git ls-files --others --exclude-standard 2>$null | Measure-Object).Count
        $totalDirty     = $stagedCount + $unstagedCount + $untrackedCount

        $aheadCount  = 0
        $behindCount = 0
        $upstreamBranch = git rev-parse --abbrev-ref "@{u}" 2>$null
        if ($upstreamBranch -and $LASTEXITCODE -eq 0) {
            $aheadCount  = [int](git rev-list --count "@{u}..HEAD" 2>$null)
            $behindCount = [int](git rev-list --count "HEAD..@{u}" 2>$null)
        }

        $stashCount = (git stash list 2>$null | Measure-Object).Count

        $gitColor  = if ($totalDirty -gt 0) { $neonPink } else { $teal }
        $gitStatus = "${gitColor}${branch}${rst}"
        if ($totalDirty -gt 0) { $gitStatus += "${neonPink}+${totalDirty}${rst}" }
        if ($aheadCount  -gt 0) { $gitStatus += " ${cyan}↑${aheadCount}${rst}" }
        if ($behindCount -gt 0) { $gitStatus += " ${orange}↓${behindCount}${rst}" }
        if ($stashCount  -gt 0) { $gitStatus += " ${cyan}≡${stashCount}${rst}" }

        $parts += $gitStatus
    } else {
        $parts += "${dim}no-git${rst}"
    }

    # === Model + effort ===
    $modelShort = $model -replace '^Claude ', '' -replace '\s*context', ''
    $effortLevel = $data.effort.level
    $effortMap = @{
        'low'    = @{ label = 'low'; color = $dim }
        'medium' = @{ label = 'med'; color = $sage }
        'high'   = @{ label = 'hig'; color = $yellow }
        'xhigh'  = @{ label = 'xhi'; color = $orange }
        'max'    = @{ label = 'max'; color = $hotRed }
    }
    $thinking = $data.thinking.enabled
    $modelPart = "${lavender}${modelShort} ${rst}"
    if ($thinking) {
        $modelPart += "${lightBlue}✦ ${rst}"
    } else {
        $modelPart += "${dim}✦ ${rst}"
    }
    if ($effortLevel -and $effortMap.ContainsKey($effortLevel)) {
        $e = $effortMap[$effortLevel]
        $modelPart += "$($e.color)$($e.label)${rst}"
    }
    $parts += $modelPart

    # === Context usage ===
    $pct = $data.context_window.used_percentage
    $isTightModel = ($model -match 'opus') -or ($model -match 'Sonnet 5') -or ($data.model.id -match 'sonnet-5')
    if ($pct -ne $null) {
        $pctInt = [int]$pct
        Send-ContextThresholdAlert -PctInt $pctInt -SessionId $data.session_id -ContextLabel (Split-Path $workspaceDir -Leaf)
        if ($isTightModel) {
            $pctColor = Get-UsageColorTight $pctInt
        } else {
            $pctColor = Get-UsageColor $pctInt
        }
        $parts += "${pctColor}${pct}%${rst}"
    } else {
        $parts += "${dim}Ctx: -${rst}"
    }

    # === Weekly limit (usage + days remaining + daily pending ratio) ===
    $wkLine = $null
    $wkUsed = $data.rate_limits.seven_day.used_percentage
    $wkReset = $data.rate_limits.seven_day.resets_at
    if ($wkUsed -ne $null) {
        $wkRemain = 100 - [int]$wkUsed
        if ($wkReset -ne $null) {
            $now = [int][double]::Parse((Get-Date -UFormat %s))
            $days = [math]::Round(($wkReset - $now) / 86400.0, 1)
            if ($days -gt 0) {
                $dailyPct = [math]::Round($wkRemain / $days, 0)
                $wkLine = "${dim}{0:0.0}d ${wkRemain}% {1:0}%/d${rst}" -f $days, $dailyPct
            } else {
                $wkLine = "${dim}0.0d ${wkRemain}%${rst}"
            }
        } else {
            $wkLine = "${dim}${wkRemain}%${rst}"
        }
    }

    # === Assemble ===
    $sep = " ${dim}|${rst} "
    $line1 = $parts -join $sep

    # === CWD (line 2) ===
    $cwd = $data.cwd -replace '\\', '/'
    $homeDir = $env:USERPROFILE -replace '\\', '/'
    if ($cwd -like "${homeDir}/*") {
        $cwd = "~" + $cwd.Substring($homeDir.Length)
    } elseif ($cwd -eq $homeDir) {
        $cwd = "~"
    }

    if ($wkLine) {
        Write-Output "$line1`n$wkLine`n${dim}${cwd}${rst}"
    } else {
        Write-Output "$line1`n${dim}${cwd}${rst}"
    }
} finally {
    Pop-Location
}

} catch {
    $hotRed = "`e[38;5;203m"
    $rst    = "`e[0m"
    Write-Output "${hotRed}statusline error: $_${rst}"
}
