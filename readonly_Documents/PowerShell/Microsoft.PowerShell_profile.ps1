Import-Module scoop-completion
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (& { (chezmoi completion powershell | Out-String) })
# oh-my-posh init pwsh --config 'jandedobbeleer' | Invoke-Expression

# oh-my-posh init pwsh | Invoke-Expression

# $Env:EDITOR = "notepad.exe"
Set-PSReadLineKeyHandler -Key Ctrl+w -Function UnixWordRubout
