# Lazy loader for scoop-completion
# Registers a stub completer that loads the real module on first Tab press

Register-ArgumentCompleter -Native -CommandName scoop, scoop.ps1, scoop.cmd -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorColumn)

    # Load the real module (this will overwrite this completer)
    Import-Module "$env:USERPROFILE\scoop\modules\scoop-completion" -Global

    # Re-invoke completion now that real module is loaded
    $completion = [System.Management.Automation.CommandCompletion]::CompleteInput(
        $commandAst.ToString(),
        $cursorColumn,
        $null
    )

    $completion.CompletionMatches
}
