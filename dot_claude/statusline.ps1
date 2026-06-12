# Git-aware statusLine script for Claude Code
param()

try {

# Read JSON input from stdin
$inputText = $input | Out-String
$data = $inputText | ConvertFrom-Json

# Dump full stdin payload (pretty JSON) for inspection
$data | ConvertTo-Json -Depth 20 | Set-Content -Path "$env:USERPROFILE/.claude/statusline-dump.json" -Encoding utf8

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
function Get-UsageColor([int]$p) {
    if ($p -le 20) {
        $t = $p / 20.0
        $r = [int](60 + (230 - 60) * $t); $g = [int](220 + (165 - 220) * $t); $b = [int](90 + (60 - 90) * $t)
    } elseif ($p -le 75) {
        $t = ($p - 20) / 55.0
        $r = [int](230 + (220 - 230) * $t); $g = [int](165 + (100 - 165) * $t); $b = [int](60 + (48 - 60) * $t)
    } else {
        $t = ($p - 75) / 25.0
        $r = [int](220 + (205 - 220) * $t); $g = [int](100 + (35 - 100) * $t); $b = [int](48 + (35 - 48) * $t)
    }
    "`e[38;2;$r;$g;${b}m"
}

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
    if ($pct -ne $null) {
        $pctColor = Get-UsageColor ([int]$pct)
        $parts += "${pctColor}Ctx: ${pct}%${rst}"
    } else {
        $parts += "${dim}Ctx: -${rst}"
    }

    # === Weekly limit (usage + days remaining, gray, own line) ===
    $wkLine = $null
    $wkUsed = $data.rate_limits.seven_day.used_percentage
    $wkReset = $data.rate_limits.seven_day.resets_at
    if ($wkUsed -ne $null) {
        $wkRemain = 100 - [int]$wkUsed
        if ($wkReset -ne $null) {
            $now = [int][double]::Parse((Get-Date -UFormat %s))
            $days = [math]::Round(($wkReset - $now) / 86400.0, 1)
            $wkLine = "${dim}{0:0.0}d ${wkRemain}%${rst}" -f $days
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
