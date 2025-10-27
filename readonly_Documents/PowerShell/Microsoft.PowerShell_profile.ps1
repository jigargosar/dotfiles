Import-Module scoop-completion
# . "$PSScriptRoot\zoxide-init.ps1"
# . "$PSScriptRoot\chezmoi_completion.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# $Env:EDITOR = "notepad.exe"

# Sync-Chezmoi module - load if installed
$syncChezmoiPath = "$HOME\Documents\PowerShell\Modules\Sync-Chezmoi"
if (Test-Path $syncChezmoiPath) {
    Import-Module Sync-Chezmoi
}

# === Sync-Chezmoi Module Management Functions ===

function Install-SyncChezmoi {
    $syncChezmoiPath = "$HOME\Documents\PowerShell\Modules\Sync-Chezmoi"
    if (Test-Path $syncChezmoiPath) {
        Write-Host "Sync-Chezmoi already installed at $syncChezmoiPath" -ForegroundColor Yellow
        return
    }
    git clone --depth 1 https://github.com/jigargosar/powershell-sync-chezmoi.git $syncChezmoiPath
    Write-Host "Sync-Chezmoi installed successfully" -ForegroundColor Green
}

function Update-SyncChezmoi {
    $syncChezmoiPath = "$HOME\Documents\PowerShell\Modules\Sync-Chezmoi"
    if (-not (Test-Path $syncChezmoiPath)) {
        Write-Host "Sync-Chezmoi not installed. Run Install-SyncChezmoi first." -ForegroundColor Red
        return
    }
    git -C $syncChezmoiPath pull
    Write-Host "Sync-Chezmoi updated successfully" -ForegroundColor Green
}

function Remove-SyncChezmoi {
    $syncChezmoiPath = "$HOME\Documents\PowerShell\Modules\Sync-Chezmoi"
    if (-not (Test-Path $syncChezmoiPath)) {
        Write-Host "Sync-Chezmoi not installed" -ForegroundColor Yellow
        return
    }
    Remove-Item -Recurse -Force $syncChezmoiPath
    Write-Host "Sync-Chezmoi removed successfully" -ForegroundColor Green
}