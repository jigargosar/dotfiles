# ==============================================================================
# POWERSHELL PROFILE (The High-Performance Final Version)
# ==============================================================================
$profileStartTime = [datetime]::UtcNow

# --- 1. PERFORMANCE CACHING SETUP ---
$cacheDir = "$HOME\.cache\pwsh"
if (!(Test-Path $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }

function Import-Cached {
    param($Name, $Command)
    $cacheFile = "$cacheDir\$Name.ps1"
    if (!(Test-Path $cacheFile)) {
        Invoke-Expression $Command | Out-File $cacheFile
    }
    . $cacheFile
}

# --- 2. TOOLS & COMPLETIONS ---
# Hardcoding the scoop-completion path avoids the 50ms "Discovery" lag
$scoopCompletion = "$HOME\scoop\modules\scoop-completion\scoop-completion.ps1"
if (Test-Path $scoopCompletion) { . $scoopCompletion } 

Import-Cached "zoxide" "zoxide init powershell"
Import-Cached "chezmoi" "chezmoi completion powershell"

# --- 3. KEYBINDINGS ---
Set-PSReadLineKeyHandler -Key Ctrl+w -Function UnixWordRubout

# --- 4. WINDOWS TERMINAL: DIRECTORY REPORTING & CLEAN UI ---
$oldPrompt = $function:prompt
function prompt {
    # 1. Path Setup
    $realPath = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $homePath = $HOME.Replace('\', '/')
    $displayPath = $realPath.Replace('\', '/').Replace($homePath, "~")
    if (!$displayPath.EndsWith('/')) { $displayPath += '/' }
    
    # RESTORED: This line enables Windows Terminal "Duplicate Tab" functionality
    Write-Host "$([char]27)]9;9;`"$realPath`"$([char]27)\" -NoNewline

    # 2. Git Information (Using rev-parse for accuracy)
    $gitBlock = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        # Explicitly get the branch name (removes the [#] / [HEAD] bugs)
        $branchName = git rev-parse --abbrev-ref HEAD 2>$null
        
        if ($branchName) {
            # Get everything else in one porcelain call
            $status = git status --porcelain --branch 2>$null
            
            # Extract Ahead/Behind from the first line
            $ahead  = if ($status[0] -match 'ahead\s(\d+)')  { " ↑$($Matches[1])" } else { "" }
            $behind = if ($status[0] -match 'behind\s(\d+)') { " ↓$($Matches[1])" } else { "" }
            
            # File counts
            $dirtyCount = $status.Count - 1
            $plus = if ($dirtyCount -gt 0) { " +$dirtyCount" } else { "" }

            # Color Logic
            $statusColor = "Green"
            if ($dirtyCount -gt 0) { $statusColor = "Red" }
            elseif ($ahead -or $behind) { $statusColor = "Cyan" }

            $gitBlock = "[$branchName$plus$ahead$behind]"
        }
    }

    # 3. Render Top Line (Right Aligned)
    Write-Host "`n$displayPath" -ForegroundColor Cyan -NoNewline
    
    if ($gitBlock) {
        $pad = $Host.UI.RawUI.WindowSize.Width - $displayPath.Length - $gitBlock.Length
        if ($pad -gt 0) { Write-Host (" " * $pad) -NoNewline }
        else { Write-Host " " -NoNewline }
        Write-Host $gitBlock -ForegroundColor $statusColor -NoNewline
    }

    # 4. Input Line
    return "`n> "
}

# --- 5. STARTUP TELEMETRY ---
$profileDuration = [math]::Round(([datetime]::UtcNow - $profileStartTime).TotalMilliseconds)
if ($profileDuration -gt 50) {
    Write-Host "Profile loaded in $($profileDuration)ms" -ForegroundColor Gray
}
# ==============================================================================
