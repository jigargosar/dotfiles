Import-Module scoop-completion
# . "$PSScriptRoot\zoxide-init.ps1"
# . "$PSScriptRoot\chezmoi_completion.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# $Env:EDITOR = "notepad.exe"

# Sync-Chezmoi function moved to separate file for development with git
# Hardlinked from: C:\Users\jigar\projects\powershell-sync-chezmoi\Sync-Chezmoi.ps1
. "$PSScriptRoot\Sync-Chezmoi.ps1"

<#
# Original inline function (commented for posterity):
function Sync-Chezmoi {
    # TODO: Fix chezmoi diff doesn't work properly for deleted files
    # TODO: Handle deleted files properly with chezmoi forget

    # REFACTORING PLAN:
    # Development workflow:
    # 1. Create ~/projects/powershell-chezmoi-sync git repo
    # 2. Copy this function to project
    # 3. Comment out this function in profile (temporary)
    # 4. Refactor & test in project dir with git
    # 5. Once stable, install from profile using Install/Update functions
    #
    # Code refactoring tasks:
    # 1. Extract Get-UserConfirmation - handle Y/Enter/Esc pattern
    # 2. Extract Test-UnpushedCommits - check git branch status
    # 3. Extract Show-ChezmoiDiff - display diff workflow
    # 4. Extract Invoke-ChezmoiReAdd - re-add workflow
    # 5. Extract Sync-ChezmoiGit - commit/push workflow
    # 6. Simplify main function to coordinator
    #
    # Integration (after development):
    # 1. Add Install-ChezmoiSyncModule function to profile
    # 2. Add Update-ChezmoiSyncModule function to profile
    # 3. Profile clones module to Modules/ChezmoiSync via git
    # 4. Add Modules/ChezmoiSync to .chezmoiignore

    $gitStatus = chezmoi git -- status --short
    $gitBranch = chezmoi git -- status --branch --porcelain

    # Check for uncommitted changes
    if (-not [string]::IsNullOrWhiteSpace($gitStatus)) {
        Write-Host "Warning: Uncommitted changes" -ForegroundColor Yellow
        Write-Host $gitStatus
        Write-Host
    }
    # Check for un-pushed commits
    elseif ($gitBranch -match '\[ahead \d+\]') {
        Write-Host "Warning: Un-pushed commits" -ForegroundColor Yellow
        Write-Host
    }

    $status = chezmoi status

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "Everything in sync." -ForegroundColor Green

        # Check for unpushed commits again
        $gitBranchAfter = chezmoi git -- status --branch --porcelain
        if ($gitBranchAfter -match '\[ahead \d+\]') {
            Write-Host
            Write-Host "Push changes? (Y/Enter or Esc to abort): " -NoNewline
            $pushChoice = [Console]::ReadKey($true)
            Write-Host

            if ($pushChoice.Key -eq 'Escape' -or ($pushChoice.Modifiers -eq 'Control' -and $pushChoice.Key -eq 'C')) {
                Write-Host "Aborted." -ForegroundColor Yellow
                return
            }

            if ($pushChoice.KeyChar.ToString().ToUpper() -eq "Y" -or $pushChoice.Key -eq 'Enter') {
                chezmoi git -- push
                Write-Host "Pushed" -ForegroundColor Green
            } else {
                Write-Host "Aborted." -ForegroundColor Yellow
            }
        }
        return
    }

    Write-Host "=== chezmoi status ===" -ForegroundColor Cyan
    Write-Output $status
    Write-Host

    Write-Host "Show diff? (Y/Enter or Esc to abort): " -NoNewline
    $diffChoice = [Console]::ReadKey($true)
    Write-Host

    if ($diffChoice.Key -eq 'Escape' -or ($diffChoice.Modifiers -eq 'Control' -and $diffChoice.Key -eq 'C')) {
        Write-Host "Aborted." -ForegroundColor Yellow
        return
    }

    if ($diffChoice.KeyChar.ToString().ToUpper() -eq "Y" -or $diffChoice.Key -eq 'Enter') {
        chezmoi diff
    } else {
        Write-Host "Aborted." -ForegroundColor Yellow
        return
    }
    Write-Host

    Write-Host "=== Re-add ===" -ForegroundColor Cyan
    Write-Host "Run re-add? (Y/Enter or Esc to abort): " -NoNewline
    $choice = [Console]::ReadKey($true)
    Write-Host

    if ($choice.Key -eq 'Escape' -or ($choice.Modifiers -eq 'Control' -and $choice.Key -eq 'C')) {
        Write-Host "Aborted." -ForegroundColor Yellow
        return
    }

    if ($choice.KeyChar.ToString().ToUpper() -eq "Y" -or $choice.Key -eq 'Enter') {
        chezmoi re-add
        Write-Host "Re-added" -ForegroundColor Green
        Write-Host

        # Check git status after re-add
        $gitStatusAfter = chezmoi git -- status --short
        if (-not [string]::IsNullOrWhiteSpace($gitStatusAfter)) {
            Write-Host "=== chezmoi git status ===" -ForegroundColor Cyan
            Write-Output $gitStatusAfter
            Write-Host

            Write-Host "Commit changes? [C] Commit and push / [O] Commit only / [A] Abort: " -NoNewline
            $commitChoice = [Console]::ReadKey($true)
            Write-Host

            if ($commitChoice.Key -eq 'Escape' -or ($commitChoice.Modifiers -eq 'Control' -and $commitChoice.Key -eq 'C')) {
                Write-Host "Aborted." -ForegroundColor Yellow
                return
            }

            $key = $commitChoice.KeyChar.ToString().ToUpper()
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
                Write-Host "Aborted." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "Aborted." -ForegroundColor Yellow
    }
}
#>