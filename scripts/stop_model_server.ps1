$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$pidPath = Join-Path $projectRoot "runtime\plantcare-server.pid"

if (-not (Test-Path -LiteralPath $pidPath -PathType Leaf)) {
    Write-Host "No PlantCare-VL process record was found."
    exit 0
}

$serverPid = Get-Content -LiteralPath $pidPath
$serverProcess = Get-Process -Id $serverPid -ErrorAction SilentlyContinue

if ($serverProcess) {
    Stop-Process -Id $serverPid
    $serverProcess.WaitForExit()
    Write-Host "PlantCare-VL has stopped."
}
else {
    Write-Host "PlantCare-VL is not running."
}

Clear-Content -LiteralPath $pidPath
