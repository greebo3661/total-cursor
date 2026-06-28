#Requires -Version 7.0
<#
.SYNOPSIS
  Verify total-cursor installation: hook smoke tests and AgentShield scan.
#>
[CmdletBinding()]
param(
    [string]$CursorHome = (Join-Path $env:USERPROFILE '.cursor')
)

$ErrorActionPreference = 'Stop'
$failures = 0

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Assert-ExitCode {
    param(
        [int]$Expected,
        [int]$Actual,
        [string]$Label
    )
    if ($Actual -ne $Expected) {
        Write-Host "FAIL: $Label (expected exit $Expected, got $Actual)" -ForegroundColor Red
        script:failures++
    }
    else {
        Write-Host "OK:   $Label" -ForegroundColor Green
    }
}

Write-Step "Verifying installation at $CursorHome"

$hooksDir = Join-Path $CursorHome 'hooks'
$submitHook = Join-Path $hooksDir 'before-submit-prompt.js'
$tabHook = Join-Path $hooksDir 'before-tab-file-read.js'

if (-not (Test-Path $submitHook)) {
    Write-Host "FAIL: missing $submitHook" -ForegroundColor Red
    $failures++
}
else {
    Write-Step 'Hook smoke: secret detection (warn, exit 0)'
    '{"prompt":"my key is sk-abcdefghijklmnopqrstuvwxyz123456"}' | node $submitHook | Out-Null
    Assert-ExitCode -Expected 0 -Actual $LASTEXITCODE -Label 'before-submit-prompt.js'
}

if (-not (Test-Path $tabHook)) {
    Write-Host "FAIL: missing $tabHook" -ForegroundColor Red
    $failures++
}
else {
    Write-Step 'Hook smoke: tab read block (exit 2)'
    '{"path":"config/voice-bot.env"}' | node $tabHook | Out-Null
    Assert-ExitCode -Expected 2 -Actual $LASTEXITCODE -Label 'before-tab-file-read.js'
}

Write-Step 'Inventory'
$skills = (Get-ChildItem (Join-Path $CursorHome 'skills') -Directory -ErrorAction SilentlyContinue).Count
$rules = (Get-ChildItem (Join-Path $CursorHome 'rules') -File -ErrorAction SilentlyContinue).Count
$agents = (Get-ChildItem (Join-Path $CursorHome 'agents') -File -ErrorAction SilentlyContinue).Count
Write-Host "  skills: $skills"
Write-Host "  rules:  $rules"
Write-Host "  agents: $agents"

Write-Step 'AgentShield scan'
Push-Location $CursorHome
try {
    npx --yes ecc-agentshield@latest scan 2>&1 | Select-Object -Last 20
    if ($LASTEXITCODE -gt 1) {
        Write-Host "WARN: AgentShield exit code $LASTEXITCODE (review findings above)" -ForegroundColor Yellow
    }
}
finally {
    Pop-Location
}

Write-Step 'Summary'
if ($failures -gt 0) {
    Write-Host "Verification finished with $failures failure(s)." -ForegroundColor Red
    exit 1
}
Write-Host 'Verification passed.' -ForegroundColor Green
