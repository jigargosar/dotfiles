# Git-aware statusLine script for Claude Code
param()

# Read JSON input from stdin
$inputText = $input | Out-String
$data = $inputText | ConvertFrom-Json

# Get basic info
$currentDir = Split-Path -Leaf $data.workspace.current_dir
$model = $data.model.display_name
$workspaceDir = $data.workspace.current_dir

# DEBUG: Uncomment to see raw JSON
# Write-Output "=== RAW JSON DATA ==="
# Write-Output $inputText
# exit

# Calculate consumed context percentage with color coding
$contextPart = ""
if ($data.context_window.current_usage -ne $null) {
    $currentTokens = $data.context_window.current_usage.input_tokens +
                     $data.context_window.current_usage.cache_creation_input_tokens +
                     $data.context_window.current_usage.cache_read_input_tokens
    $windowSize = $data.context_window.context_window_size
    $usedPercentage = [math]::Floor(($currentTokens * 100) / $windowSize)

    # Color code based on usage level
    $ctxColor = if ($usedPercentage -lt 50) {
        "$($PSStyle.Foreground.Green)"
    } elseif ($usedPercentage -lt 75) {
        "$($PSStyle.Foreground.Yellow)"
    } else {
        "$($PSStyle.Foreground.Red)"
    }

    $contextPart = " [Ctx: ${ctxColor}${usedPercentage}%$($PSStyle.Reset)]"
}

# PowerShell 7.2+ PSStyle colors
$greenColor = "$($PSStyle.Foreground.Green)"
$redColor = "$($PSStyle.Foreground.Red)"
$resetColor = "$($PSStyle.Reset)"

# Change to workspace directory for git commands
Push-Location $workspaceDir

try {
    # Check if we're in a git repository
    $isGitRepo = $false
    try {
        git rev-parse --git-dir 2>$null | Out-Null
        $isGitRepo = $true
    } catch {
        $isGitRepo = $false
    }

    if ($isGitRepo) {
        # Get current branch
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if (!$branch) { $branch = "unknown" }

        # Count dirty files (staged + unstaged + untracked)
        $stagedCount = (git diff --cached --name-only 2>$null | Measure-Object).Count
        $unstagedCount = (git diff --name-only 2>$null | Measure-Object).Count
        $untrackedCount = (git ls-files --others --exclude-standard 2>$null | Measure-Object).Count
        $totalDirty = $stagedCount + $unstagedCount + $untrackedCount

        # Build the status string with colors
        if ($totalDirty -gt 0) {
            # Dirty state: branch+count in red
            $gitPart = "${redColor}${branch}+${totalDirty}${resetColor}"
        } else {
            # Clean state: branch in green
            $gitPart = "${greenColor}${branch}${resetColor}"
        }

        # Output the complete status line
        $statusLine = "${gitPart} [${model}]${contextPart}"
    } else {
        # Not a git repo, just show model
        $statusLine = "[${model}]${contextPart}"
    }

    # Output status line
    Write-Output $statusLine

    # DEBUG: Uncomment to append raw JSON data
    # Write-Output "`n=== RAW JSON DATA ==="
    # Write-Output $inputText
} finally {
    Pop-Location
}