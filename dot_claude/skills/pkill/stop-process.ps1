$PSStyle.OutputRendering = "PlainText"
$ProgressPreference = "SilentlyContinue"
$env:NO_COLOR = "1"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$yaml = $input | Out-String

foreach ($match in [regex]::Matches($yaml, "pid:\s*(\d+)")) {
  $id = $match.Groups[1].Value
  try {
    Stop-Process -Id $id -Force
    Write-Output "Killed PID $id"
  } catch {
    Write-Output "Failed PID $id : $_"
  }
}
