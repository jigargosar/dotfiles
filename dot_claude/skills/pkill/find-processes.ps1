param([string]$SearchTerm)

$PSStyle.OutputRendering = "PlainText"
$ProgressPreference = "SilentlyContinue"
$env:NO_COLOR = "1"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$processes = Get-CimInstance Win32_Process |
  Where-Object { $_.CommandLine -like "*$SearchTerm*" -and $_.Name -ne "pwsh.exe" -and $_.Name -ne "bash.exe" }

if ($processes.Count -eq 0) {
  Write-Output "No processes found matching '$SearchTerm'"
  exit 0
}

foreach ($p in $processes) {
  $cmd = $p.CommandLine -replace '\\', '/' -replace '"', ''
  Write-Output "- pid: $($p.ProcessId)"
  Write-Output "  name: $($p.Name)"
  Write-Output "  cmd: $cmd"
  Write-Output ""
}
