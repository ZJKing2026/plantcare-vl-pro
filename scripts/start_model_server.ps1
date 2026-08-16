$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$runtimePath = Join-Path $projectRoot "runtime\llama.cpp\llama-server.exe"
$modelPath = Join-Path $projectRoot "models\qwen3vl-4b-formal-v1\plantcare-qwen3vl-4b-formal-v1-q4_k_m.gguf"
$mmprojPath = Join-Path $projectRoot "models\qwen3vl-4b-formal-v1\mmproj-plantcare-qwen3vl-4b-formal-v1-f16.gguf"
$runtimeDirectory = Join-Path $projectRoot "runtime"
$pidPath = Join-Path $runtimeDirectory "plantcare-server.pid"
$logPath = Join-Path $runtimeDirectory "plantcare-server.log"
$errorLogPath = Join-Path $runtimeDirectory "plantcare-server-error.log"
$serverUrl = "http://127.0.0.1:8080"

foreach ($requiredPath in @($runtimePath, $modelPath, $mmprojPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Required file not found: $requiredPath"
    }
}

if (Test-Path -LiteralPath $pidPath) {
    $existingPid = Get-Content -LiteralPath $pidPath -ErrorAction SilentlyContinue
    $existingProcess = if ($existingPid) {
        Get-Process -Id $existingPid -ErrorAction SilentlyContinue
    }
    else {
        $null
    }
    if ($existingProcess) {
        Write-Host "PlantCare-VL is already running. Opening the browser."
        Start-Process $serverUrl
        exit 0
    }
}

$arguments = @(
    "-m", "`"$modelPath`"",
    "--mmproj", "`"$mmprojPath`"",
    "--host", "127.0.0.1",
    "--port", "8080",
    "-c", "4096",
    "-np", "1",
    "-ngl", "0",
    "--no-mmproj-offload",
    "--jinja"
)

$serverProcess = Start-Process `
    -FilePath $runtimePath `
    -ArgumentList $arguments `
    -WorkingDirectory $projectRoot `
    -RedirectStandardOutput $logPath `
    -RedirectStandardError $errorLogPath `
    -WindowStyle Hidden `
    -PassThru

Set-Content -LiteralPath $pidPath -Value $serverProcess.Id -Encoding ascii
Write-Host "Loading PlantCare-VL. This may take up to a minute."

for ($attempt = 1; $attempt -le 120; $attempt++) {
    if ($serverProcess.HasExited) {
        throw "The model server exited. Check the log: $errorLogPath"
    }

    try {
        $response = Invoke-WebRequest `
            -Uri "$serverUrl/health" `
            -UseBasicParsing `
            -TimeoutSec 2
        if ($response.StatusCode -eq 200) {
            Write-Host "PlantCare-VL is ready: $serverUrl"
            Start-Process $serverUrl
            exit 0
        }
    }
    catch {
        Start-Sleep -Seconds 1
    }
}

throw "Model loading timed out. Check the log: $errorLogPath"
