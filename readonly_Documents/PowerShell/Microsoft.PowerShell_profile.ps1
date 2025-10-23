Import-Module scoop-completion
# . "$PSScriptRoot\zoxide-init.ps1"
# . "$PSScriptRoot\chezmoi_completion.ps1"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# $Env:EDITOR = "notepad.exe"