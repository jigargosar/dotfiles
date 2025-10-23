Import-Module scoop-completion
# . "$PSScriptRoot\zoxide-init.ps1"
# . "$PSScriptRoot\chezmoi_completion.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# $Env:EDITOR = "notepad.exe"

function Sync-Chezmoi {
    Write-Host "=== Checking Git Status ===" -ForegroundColor Cyan
    $gitStatus = chezmoi git -- status --short
    $gitBranch = chezmoi git -- status --branch --porcelain

    # Check for uncommitted changes
    if (-not [string]::IsNullOrWhiteSpace($gitStatus)) {
        Write-Host "Uncommitted changes:" -ForegroundColor Yellow
        Write-Host $gitStatus
        Write-Host "`nCommit and push changes? [Y] Yes / [S] Skip / [A] Abort: " -NoNewline
        $choice = [Console]::ReadKey($true).KeyChar
        Write-Host $choice

        switch ($choice.ToString().ToUpper()) {
            "Y" {
                Write-Host "`nCommitting and pushing..." -ForegroundColor Green
                $commitMsg = "Update dotfiles $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
                chezmoi git -- add -A
                chezmoi git -- commit -m $commitMsg
                chezmoi git -- push
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "Failed to commit/push." -ForegroundColor Red
                    return
                }
            }
            "S" {
                # Continue silently
            }
            default {
                Write-Host "Aborted." -ForegroundColor Yellow
                return
            }
        }
    }
    # Check for un-pushed commits
    elseif ($gitBranch -match '\[ahead \d+\]') {
        Write-Host "Un-pushed commits found." -ForegroundColor Yellow
        Write-Host "Push changes? [Y] Yes / [S] Skip / [A] Abort: " -NoNewline
        $choice = [Console]::ReadKey($true).KeyChar
        Write-Host $choice

        switch ($choice.ToUpper()) {
            "Y" {
                Write-Host "`nPushing..." -ForegroundColor Green
                chezmoi git -- push
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "Failed to push." -ForegroundColor Red
                    return
                }
            }
            "S" {
                # Continue silently
            }
            default {
                Write-Host "Aborted." -ForegroundColor Yellow
                return
            }
        }
    }

    Write-Host "`n=== Checking System Changes ===" -ForegroundColor Cyan
    $status = chezmoi status

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Everything in sync." -ForegroundColor Green
        return
    }

    Write-Host $status
    Write-Host "`nShowing diff..." -ForegroundColor Cyan
    chezmoi diff
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Cyan

    $response = Read-Host "`nProceed with chezmoi re-add? (y/N)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host "Re-adding changes..." -ForegroundColor Green
        chezmoi re-add
        Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Cyan
    } else {
        Write-Host "Aborted." -ForegroundColor Yellow
        return
    }
}