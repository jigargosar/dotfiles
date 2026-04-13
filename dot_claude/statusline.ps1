# Git-aware statusLine script for Claude Code
param()

$hotRed = "`e[38;5;203m"
$rst = "`e[0m"

try {

# Read JSON input from stdin
$inputText = $input | Out-String
$data = $inputText | ConvertFrom-Json

# Dump full stdin payload (pretty JSON) for inspection
$data | ConvertTo-Json -Depth 20 | Set-Content -Path "$env:USERPROFILE/.claude/statusline-dump.json" -Encoding utf8

# Get basic info
$model = $data.model.display_name
$workspaceDir = $data.workspace.current_dir

# Truecolor palette (Neon Cyberpunk)
$teal = "`e[38;2;140;255;200m"     # electric teal — clean branch
$neonPink = "`e[38;2;255;50;120m"  # neon pink — dirty branch + dirty count
$cyan = "`e[38;2;80;200;255m"      # cyan — push pending
$orange = "`e[38;2;255;180;50m"    # vivid orange — pull pending
$lavender = "`e[38;5;183m"         # lavender — model
$lightBlue = "`e[38;2;150;200;255m" # light blue — thinking mode
$sage = "`e[38;5;150m"             # sage green — context
$yellow = "`e[38;5;179m"           # warm yellow — ctx warning
$hotRed = "`e[38;5;203m"           # hot red — ctx critical
$dim = "`e[38;5;240m"              # dim — separator
$rst = "`e[0m"

# Previous format (bracketed, PSStyle colors):
#   "${gitPart} [${model}]${contextPart}${parkedPart}"
#   e.g. "main [Opus 4.6] [Ctx: 12%] [P: 1]"
# Switched to pipe-separated with 256-color palette for visual harmony.

Push-Location $workspaceDir

try {
    $parts = @()

    # === Git status ===
    git rev-parse --git-dir 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if (!$branch) { $branch = "?" }

        $stagedCount = (git diff --cached --name-only 2>$null | Measure-Object).Count
        $unstagedCount = (git diff --name-only 2>$null | Measure-Object).Count
        $untrackedCount = (git ls-files --others --exclude-standard 2>$null | Measure-Object).Count
        $totalDirty = $stagedCount + $unstagedCount + $untrackedCount

        # Count ahead/behind remote
        $aheadCount = 0
        $behindCount = 0
        $upstreamBranch = git rev-parse --abbrev-ref "@{u}" 2>$null
        if ($upstreamBranch -and $LASTEXITCODE -eq 0) {
            $aheadCount = [int](git rev-list --count "@{u}..HEAD" 2>$null)
            $behindCount = [int](git rev-list --count "HEAD..@{u}" 2>$null)
        }

        # Count stashes
        $stashCount = (git stash list 2>$null | Measure-Object).Count

        # Build git status string: main+3 ↑2 ↓1 S:2
        $gitColor = if ($totalDirty -gt 0) { $neonPink } else { $teal }
        $gitStatus = "${gitColor}${branch}${rst}"
        if ($totalDirty -gt 0) {
            $gitStatus += "${neonPink}+${totalDirty}${rst}"
        }
        if ($aheadCount -gt 0) {
            $gitStatus += " ${cyan}↑${aheadCount}${rst}"
        }
        if ($behindCount -gt 0) {
            $gitStatus += " ${orange}↓${behindCount}${rst}"
        }
        if ($stashCount -gt 0) {
            $gitStatus += " ${cyan}≡${stashCount}${rst}"
        }

        $parts += $gitStatus
    } else {
        $parts += "${dim}no-git${rst}"
    }

    # === Model ===
    $parts += "${lavender}${model}${rst}"

    # === Context usage ===
    if ($data.context_window.current_usage -ne $null) {
        $currentTokens = $data.context_window.current_usage.input_tokens +
                         $data.context_window.current_usage.cache_creation_input_tokens +
                         $data.context_window.current_usage.cache_read_input_tokens
        $windowSize = $data.context_window.context_window_size
        $pct = [math]::Floor(($currentTokens * 100) / $windowSize)

        $pctColor = if ($pct -lt 50) { $sage } elseif ($pct -lt 75) { $yellow } else { $hotRed }
        $parts += "${sage}Ctx: ${pctColor}${pct}%${rst}"
    } else {
        $parts += "${sage}Ctx: -${rst}"
    }

    # === Assemble ===
    $sep = " ${dim}|${rst} "
    $line1 = $parts -join $sep

    # === Full path (~ prefix when under home dir) ===
    $cwd = $data.cwd -replace '\\', '/'
    $homeDir = $env:USERPROFILE -replace '\\', '/'
    if ($cwd -like "${homeDir}/*") {
        $cwd = "~" + $cwd.Substring($homeDir.Length)
    } elseif ($cwd -eq $homeDir) {
        $cwd = "~"
    }

    # === ai-research git state ===
    $aiResearchDir = "$env:USERPROFILE/projects/ai-research"
    $aiLine = ""
    if (Test-Path $aiResearchDir) {
        Push-Location $aiResearchDir
        try {
            git rev-parse --git-dir 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) {
                $aiBranch = git rev-parse --abbrev-ref HEAD 2>$null
                if (!$aiBranch) { $aiBranch = "?" }

                $aiStagedCount = (git diff --cached --name-only 2>$null | Measure-Object).Count
                $aiUnstagedCount = (git diff --name-only 2>$null | Measure-Object).Count
                $aiUntrackedCount = (git ls-files --others --exclude-standard 2>$null | Measure-Object).Count
                $aiTotalDirty = $aiStagedCount + $aiUnstagedCount + $aiUntrackedCount

                $aiAheadCount = 0
                $aiBehindCount = 0
                $aiUpstream = git rev-parse --abbrev-ref "@{u}" 2>$null
                if ($aiUpstream -and $LASTEXITCODE -eq 0) {
                    $aiAheadCount = [int](git rev-list --count "@{u}..HEAD" 2>$null)
                    $aiBehindCount = [int](git rev-list --count "HEAD..@{u}" 2>$null)
                }

                $aiStashCount = (git stash list 2>$null | Measure-Object).Count

                # Grayed versions of primary palette
                $dimTeal = "`e[38;2;130;150;140m"      # gray-green — clean branch
                $dimPink = "`e[38;2;150;125;130m"      # gray-pink — dirty branch + dirty count
                $dimCyan = "`e[38;2;130;140;150m"      # gray-cyan — push pending
                $dimOrange = "`e[38;2;150;140;130m"    # gray-orange — pull pending

                $aiGitColor = if ($aiTotalDirty -gt 0) { $dimPink } else { $dimTeal }
                $aiLine = "${dim}AR ${aiGitColor}${aiBranch}${rst}"
                if ($aiTotalDirty -gt 0) { $aiLine += "${dimPink}+${aiTotalDirty}${rst}" }
                if ($aiAheadCount -gt 0) { $aiLine += " ${dimCyan}↑${aiAheadCount}${rst}" }
                if ($aiBehindCount -gt 0) { $aiLine += " ${dimOrange}↓${aiBehindCount}${rst}" }
                if ($aiStashCount -gt 0) { $aiLine += " ${dimCyan}≡${aiStashCount}${rst}" }
            }
        } finally {
            Pop-Location
        }
    }

    $output = "$line1`n${dim}${cwd}${rst}"
    if ($aiLine) { $output += "`n${aiLine}" }
    # === Output Style ===
    $styleName = $data.output_style.name
    if ($styleName) {
        $dimLavender = "`e[38;2;140;130;160m"
        $output += " ${dim}|${rst} ${dimLavender}${styleName}${rst}"
    }

    # === Effort level (settings file + env var) ===
    $settingsPath = "$env:USERPROFILE/.claude/settings.json"
    $effortFromSettings = $null
    if (Test-Path $settingsPath) {
        try {
            $settingsJson = Get-Content $settingsPath -Raw | ConvertFrom-Json
            $effortFromSettings = $settingsJson.effortLevel
        } catch {}
    }
    $effortFromEnv = $env:CLAUDE_CODE_EFFORT_LEVEL
    $effortSettingsDisplay = if ($effortFromSettings) { $effortFromSettings } else { "-" }
    $effortEnvDisplay = if ($effortFromEnv) { $effortFromEnv } else { "-" }
    $output += " ${dim}|${rst} ${sage}effort: s=${effortSettingsDisplay} e=${effortEnvDisplay}${rst}"

    Write-Output $output
} finally {
    Pop-Location
}

} catch {
    Write-Output "${hotRed}statusline error: $_${rst}"
}
