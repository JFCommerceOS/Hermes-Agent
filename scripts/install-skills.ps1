param(
    [string]$TargetDir = $(Join-Path $env:USERPROFILE ".cursor\skills-cursor")
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
& bash "$Root/scripts/install-skills.sh" ($TargetDir -replace '\\','/')
