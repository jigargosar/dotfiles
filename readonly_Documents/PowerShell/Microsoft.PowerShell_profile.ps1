Import-Module scoop-completion
# . "$PSScriptRoot\zoxide-init.ps1"
# . "$PSScriptRoot\chezmoi_completion.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# $Env:EDITOR = "notepad.exe"

function Sync-Chezmoi {
    $gitStatus = chezmoi git -- status --short
    $gitBranch = chezmoi git -- status --branch --porcelain

    # Check for uncommitted changes
    if (-not [string]::IsNullOrWhiteSpace($gitStatus)) {
        Write-Host "Warning: Uncommitted changes" -ForegroundColor Yellow
        Write-Host $gitStatus
        Write-Host ""
    }
    # Check for un-pushed commits
    elseif ($gitBranch -match '\[ahead \d+\]') {
        Write-Host "Warning: Un-pushed commits" -ForegroundColor Yellow
        Write-Host ""
    }

    $status = chezmoi status

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Everything in sync." -ForegroundColor Green

        # Check for unpushed commits again
        $gitBranchAfter = chezmoi git -- status --branch --porcelain
        if ($gitBranchAfter -match '\[ahead \d+\]') {
            Write-Host ""
            Write-Host "Push changes? [Y] Yes / [A] Abort: " -NoNewline
            $pushChoice = [Console]::ReadKey($true).KeyChar
            Write-Host $pushChoice

            if ($pushChoice.ToString().ToUpper() -eq "Y") {
                chezmoi git -- push
                Write-Host "Pushed" -ForegroundColor Green
            } else {
                Write-Host "`nAborted." -ForegroundColor Yellow
            }
        }
        return
    }

    Write-Host "=== chezmoi status ===" -ForegroundColor Cyan
    Write-Host $status
    Write-Host ""

    Write-Host "Press any key to run 'chezmoi diff'..." -NoNewline
    [Console]::ReadKey($true) | Out-Null
    Write-Host ""

    chezmoi diff
    Write-Host ""

    Write-Host "=== Re-add ===" -ForegroundColor Cyan
    Write-Host "Proceed with chezmoi re-add? [Y] Yes / [A] Abort: " -NoNewline
    $choice = [Console]::ReadKey($true).KeyChar
    Write-Host $choice

    switch ($choice.ToString().ToUpper()) {
        "Y" {
            chezmoi re-add
            Write-Host "Re-added" -ForegroundColor Green
            Write-Host ""

            # Check git status after re-add
            $gitStatusAfter = chezmoi git -- status --short
            if (-not [string]::IsNullOrWhiteSpace($gitStatusAfter)) {
                Write-Host "=== chezmoi git status ===" -ForegroundColor Cyan
                Write-Host $gitStatusAfter
                Write-Host ""

                Write-Host "Commit changes? [C] Commit and push / [O] Commit only / [A] Abort: " -NoNewline
                $commitChoice = [Console]::ReadKey($true).KeyChar
                Write-Host $commitChoice

                $key = $commitChoice.ToString().ToUpper()
                if ($key -eq "C" -or $key -eq "O") {
                    $commitMsg = "$(Get-Date -Format 'yyyy-MM-dd HH:mm') Updated dotfiles"
                    chezmoi git -- add -A
                    chezmoi git -- commit -m $commitMsg

                    if ($key -eq "C") {
                        chezmoi git -- push
                        Write-Host "Committed and pushed" -ForegroundColor Green
                    } else {
                        Write-Host "Committed" -ForegroundColor Green
                    }
                } else {
                    Write-Host "`nAborted." -ForegroundColor Yellow
                }
            }
        }
        default {
            Write-Host "`nAborted." -ForegroundColor Yellow
            return
        }
    }
}