# ==============================================================================
# FULL POWERSHELL PROFILE (Global Lazy Loading)
# ==============================================================================

$global:StartTime = [datetime]::UtcNow

# --- 1. CORE DIRECTORIES & CACHING ---
$cacheDir = "$HOME\.cache\pwsh"
if (!(Test-Path $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }

function Import-Cached {
    param($Name, $Command)
    $cacheFile = "$cacheDir\$Name.ps1"
    if (!(Test-Path $cacheFile)) { Invoke-Expression $Command | Out-File $cacheFile }
    . $cacheFile
}

# --- 2. SHELL BEHAVIOR & PREDICTIONS ---
if ($host.Name -eq 'ConsoleHost' -and [Environment]::UserInteractive -and !([Console]::IsOutputRedirected)) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    # # Kill ring bindings
    # Set-PSReadLineKeyHandler -Key Ctrl+y -Function Yank
    # Set-PSReadLineKeyHandler -Key Alt+y  -Function YankPop

    # Path-aware deletion vs whitespace-aware deletion
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function ShellBackwardKillWord   # deletes back to / or \ boundaries
    Set-PSReadLineKeyHandler -Key Alt+w  -Function UnixWordRubout          # deletes back to whitespace
}

# --- 3. BACKGROUND INITIALIZATION (Lazy Loading) ---
$null = Register-EngineEvent -SourceIdentifier 'PowerShell.OnIdle' -MaxTriggerCount 1 -Action {
    # Zoxide
    Import-Cached "zoxide" "zoxide init powershell"
    
    # Chezmoi
    Import-Cached "chezmoi" "chezmoi completion powershell"

    # Scoop (lazy - loads real module on first Tab)
    . "$HOME\Documents\PowerShell\Scripts\scoop-completion-lazy.ps1"
}

# --- 4. THE PROMPT (Path + Git + Telemetry) ---
function prompt {
    $realPath = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $displayPath = $realPath.Replace('\', '/').Replace($HOME.Replace('\', '/'), "~")
    if (!$displayPath.EndsWith('/')) { $displayPath += '/' }
    
    if ($env:WT_SESSION) {
        Write-Host "$([char]27)]9;9;`"$realPath`"$([char]27)\" -NoNewline
    }

    # Git Status
    $gitBlock = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            $status = git status --porcelain --branch 2>$null
            $ahead  = if ($status[0] -match 'ahead\s(\d+)')  { " ↑$($Matches[1])" } else { "" }
            $behind = if ($status[0] -match 'behind\s(\d+)') { " ↓$($Matches[1])" } else { "" }
            $dirty  = $status.Count - 1
            $plus   = if ($dirty -gt 0) { " +$dirty" } else { "" }
            $statusColor = if ($dirty -gt 0) { "Red" } elseif ($ahead -or $behind) { "Cyan" } else { "Green" }
            $gitBlock = " [$branch$plus$ahead$behind]"
        }
    }

    # Telemetry line
    if ($global:StartTime) {
        $totalMs = [math]::Round(([datetime]::UtcNow - $global:StartTime).TotalMilliseconds)
        $teleColor = if ($totalMs -gt 250) { "Red" } else { "DarkGray" }
        Write-Host "Profile loaded in $($totalMs)ms" -ForegroundColor $teleColor
        $global:StartTime = $null 
    }

    Write-Host "$displayPath" -ForegroundColor Cyan -NoNewline
    if ($gitBlock) { Write-Host $gitBlock -ForegroundColor $statusColor -NoNewline }
    
    return "`n> "
}


# --- BEGIN: Remove conflicting aliases for Git usr\bin ---
Get-ChildItem "C:\Program Files\Git\usr\bin" -Filter *.exe |
    ForEach-Object {
        $name = $_.BaseName
        try {
            Remove-Item "Alias:$name" -ErrorAction SilentlyContinue
        } catch {
            # Skip constant/read-only aliases
        }
    }

# Prepend Git usr\bin to PATH
$env:Path = "C:\Program Files\Git\usr\bin;" + $env:Path
# --- END: Remove conflicting aliases for Git usr\bin ---

# Vim Mode Toggle
# ── Vi Mode Toggle ───────────────────────────────────────────
function Toggle-VimMode {
    $current = (Get-PSReadLineOption).EditMode
    if ($current -eq 'Vi') {
        Set-PSReadLineOption -EditMode Windows
        Write-Host -NoNewline "`e[6 q"  # restore beam cursor
        Write-Host "Vi mode OFF"
    } else {
        Set-PSReadLineOption -EditMode Vi
        Write-Host "Vi mode ON"
    }
}
Set-Alias tvm Toggle-VimMode

# ── Vi Mode Cursor Shape ──────────────────────────────────────
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler {
    param($mode)
    if ($mode -eq 'Command') {
        Write-Host -NoNewline "`e[2 q"  # steady block  (normal mode)
    } else {
        Write-Host -NoNewline "`e[6 q"  # steady bar    (insert mode)
    }
}
. 'C:\Users\jigar\AppData\Roaming\dystroy\broot\config\launcher\powershell\br.ps1'

# Default editor (VS Code) for jrnl, git, etc. Inner quotes keep the spaced path
# intact for shlex; forward slashes avoid backslash-escaping.
$env:EDITOR = '"C:/Users/jigar/AppData/Local/Programs/Microsoft VS Code/Code.exe" --wait --reuse-window'
