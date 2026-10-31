# ==============================================================================
# FULL POWERSHELL PROFILE (Global Lazy Loading)
# ==============================================================================
# NOTE: Import-Cached writes each cache file once and never refreshes it.
# After upgrading zoxide or chezmoi, delete the matching file in $HOME\.cache\pwsh to regenerate it.

$global:StartTime = [datetime]::UtcNow

# --- 1. CORE DIRECTORIES & CACHING ---
$cacheDir = "$HOME\.cache\pwsh"
if (!(Test-Path $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }

function Import-Cached {
    param($Name, $Command)
    $cacheFile = "$cacheDir\$Name.ps1"
    # Cache is written once. Delete the file to regenerate after an upgrade.
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

    # Backlog CLI (registers completer only; spawns backlog on first Tab)
    . "$HOME\Documents\PowerShell\Completions\backlog-completion.ps1"
}

# --- RECENT DIRECTORIES (recency only, shared across tabs/sessions) ---
$global:DirHistoryFile = "$cacheDir\dirhist.txt"

function Update-DirHistory {
    $loc = $ExecutionContext.SessionState.Path.CurrentLocation
    if ($loc.Provider.Name -ne 'FileSystem') { return }
    $path = $loc.ProviderPath
    if ($path -eq $global:DirHistoryLast) { return }
    $global:DirHistoryLast = $path
    $old = if (Test-Path $global:DirHistoryFile) { @(Get-Content $global:DirHistoryFile) } else { @() }
    @($path) + @($old | Where-Object { $_ -ne $path }) |
        Select-Object -First 50 |
        Set-Content $global:DirHistoryFile
}

# cdh: list the 9 most recently visited dirs (excluding current), pick by number
function global:cdh {
    $cur = $ExecutionContext.SessionState.Path.CurrentLocation.ProviderPath
    $dirs = @(Get-Content $global:DirHistoryFile |
        Where-Object { $_ -ne $cur -and (Test-Path -LiteralPath $_) } |
        Select-Object -First 9)
    if (-not $dirs) { Write-Host "No recent directories."; return }
    for ($i = 0; $i -lt $dirs.Count; $i++) { Write-Host ("{0}  {1}" -f ($i + 1), $dirs[$i]) }
    Write-Host "Pick 1-$($dirs.Count), Esc to cancel"
    while ($true) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq 'Escape') { return }
        $n = [int]$key.KeyChar - [int][char]'0'
        if ($n -ge 1 -and $n -le $dirs.Count) { break }
    }
    Set-Location -LiteralPath $dirs[$n - 1]
}

# --- 4. THE PROMPT (Path + Git + Telemetry) ---
function prompt {
    Update-DirHistory
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

    Write-Host "$([char]0x250C) $displayPath" -ForegroundColor Cyan -NoNewline
    if ($gitBlock) { Write-Host $gitBlock -ForegroundColor $statusColor -NoNewline }

    return "`n$([char]0x2514) $([char]0x03BB) "
}

Set-PSReadLineOption -ContinuationPrompt "  $([char]0x2502) "


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

# --- END: Remove conflicting aliases for Git usr\bin ---

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
$env:SHELL = 'C:/Users/jigar/AppData/Local/Microsoft/WindowsApps/pwsh.exe'
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit

function global:cc  { claude @args }
function global:ccc { claude --continue @args }
function global:ccr { claude --resume @args }
function global:ll  { ls.exe -al @args }
function global:zp  { z ~/projects }
function global:lp  { . $PROFILE; Write-Host "Terminal reloaded globally!" -ForegroundColor Cyan }
function global:ep  { code $PROFILE }
function global:ex  { explorer . }
function global:ws  { webstorm64.exe . }
function global:zt  { Set-Location ~/projects/tmp }
function global:pk { param([Parameter(Mandatory)][int]$port) $id = (Get-NetTCPConnection -LocalPort $port -EA 0).OwningProcess | ? {$_ -gt 0} | Select -First 1; if (-not $id) { "Not found."; return }; $p = Get-Process -Id $id; $p.Kill($true); if ($p.WaitForExit(5000)) { "Hard killed." } else { throw "Kill failed." } }
function global:mkcd { param([Parameter(Mandatory)][string] $Path); if (Test-Path -LiteralPath $Path -PathType Leaf) { throw "'$Path' is a file" }; New-Item -ItemType Directory -Path $Path -Force | Out-Null; Set-Location -LiteralPath $Path }

# pst: overwrite a file (relative or absolute path) with the clipboard contents
function global:pst {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    $target = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $content = Get-Clipboard -Raw

    if ($null -eq $content) { throw "Clipboard is empty" }

    Set-Content -LiteralPath $target -Value $content -NoNewline -Encoding utf8NoBOM
}




# =========================================================
# 1. MY PREFERRED TOOLS ORDER (Top wins conflicts)
# =========================================================
$PriorityPaths = @(
    "C:\Users\jigar\scoop\shims"
    "$HOME\bin"
    "C:\Program Files\Git\usr\bin"
)

# =========================================================
# 2. AUTOMATIC PATH CLEANER (Do not change)
# =========================================================
$AllPaths = $PriorityPaths + $env:Path.Split(';')
$env:Path = ($AllPaths | Select-Object -Unique) -join ';'

# Fixes wsl encoding
$env:WSL_UTF8 = 1


