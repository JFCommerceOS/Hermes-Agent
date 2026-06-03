# Offline bootstrap for Windows PowerShell (delegates to Git Bash scripts)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) {
    Write-Error "Git Bash 'bash' not found in PATH. Install Git for Windows."
}

Push-Location $Root
try {
    & bash "$Root/scripts/bootstrap-offline.sh"
} finally {
    Pop-Location
}
