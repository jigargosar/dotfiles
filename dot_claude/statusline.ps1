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
        $pctColor = if ($pct -lt 50) { $sage } elseif ($pct -lt 75) { $yellow } else { $hotRed }
        $parts += "${sage}Ctx: ${pctColor}${pct}%${rst}"
    } else {
        $parts += "${sage}Ctx: -${rst}"
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

    Write-Output "$line1`n${dim}${cwd}${rst}"
} finally {
    Pop-Location
}

} catch {
    $hotRed = "`e[38;5;203m"
    $rst    = "`e[0m"
    Write-Output "${hotRed}statusline error: $_${rst}"
}
