# Git-aware statusLine script for Claude Code
param()

# Read JSON input from stdin
$inputText = $input | Out-String
$data = $inputText | ConvertFrom-Json

# Get basic info
$model = $data.model.display_name
$workspaceDir = $data.workspace.current_dir

# 256-color palette
$blue = "`e[38;5;111m"      # soft blue — git
$lavender = "`e[38;5;183m"  # lavender — model
$sage = "`e[38;5;150m"      # sage green — context
$gold = "`e[38;5;180m"      # warm gold — parked
$red = "`e[38;5;167m"       # muted red — dirty git
$yellow = "`e[38;5;179m"    # warm yellow — ctx warning
$hotRed = "`e[38;5;203m"    # hot red — ctx critical
$dim = "`e[38;5;240m"       # dim — separator
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

        if ($totalDirty -gt 0) {
            $parts += "${red}${branch}+${totalDirty}${rst}"
        } else {
            $parts += "${blue}${branch}${rst}"
        }
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

    # === Parked items ===
    $parkedFile = Join-Path $workspaceDir "docs/parked.md"
    $parkedCount = 0
    if (Test-Path $parkedFile) {
        $parkedCount = (Select-String -Path $parkedFile -Pattern "^- " | Measure-Object).Count
    }
    $parts += "${gold}P: ${parkedCount}${rst}"

    # === Assemble ===
    $sep = " ${dim}|${rst} "
    Write-Output ($parts -join $sep)
} finally {
    Pop-Location
}
