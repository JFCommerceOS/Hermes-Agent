param(
    [string]$TargetDir = $(if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:USERPROFILE ".hermes-hybrid" })
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$bash = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bash) { throw "Git Bash required" }
& bash "$Root/scripts/apply-hermes-hybrid-config.sh" $TargetDir
