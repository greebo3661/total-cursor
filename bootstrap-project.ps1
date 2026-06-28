#Requires -Version 7.0
<#
.SYNOPSIS
  Bootstrap a project with .specify templates, project hooks, and optional profile overlay.
.PARAMETER ProjectPath
  Target project directory (default: current directory).
.PARAMETER Profile
  Optional profile name under profiles/ (e.g. docker-voice-bot).
.PARAMETER SkipSpecify
  Skip copying bundle/specify to project .specify/
.PARAMETER SkipHooks
  Skip creating project .cursor/hooks.json
#>
[CmdletBinding()]
param(
    [string]$ProjectPath = (Get-Location).Path,
    [string]$Profile,
    [switch]$SkipSpecify,
    [switch]$SkipHooks
)

$ErrorActionPreference = 'Stop'
$RepoRoot = $PSScriptRoot
$UserCursor = Join-Path $env:USERPROFILE '.cursor'
$ProjectPath = (Resolve-Path $ProjectPath).Path
$ProjectCursor = Join-Path $ProjectPath '.cursor'

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Copy-TreeMerge {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$ForceOverwrite
    )
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    Get-ChildItem $Source -Force | ForEach-Object {
        $target = Join-Path $Destination $_.Name
        if ($_.PSIsContainer) {
            Copy-TreeMerge -Source $_.FullName -Destination $target -ForceOverwrite:$ForceOverwrite
        }
        else {
            Copy-Item -Force $_.FullName $target
        }
    }
}

Write-Step "Bootstrapping project: $ProjectPath"
New-Item -ItemType Directory -Force -Path $ProjectCursor | Out-Null

if (-not $SkipSpecify) {
    Write-Step 'Copying .specify templates'
    $specSrc = Join-Path $RepoRoot 'bundle\specify'
    $specDst = Join-Path $ProjectPath '.specify'
    if (Test-Path $specDst) {
        Write-Host "  .specify already exists — merging files"
    }
    Copy-TreeMerge -Source $specSrc -Destination $specDst -ForceOverwrite
}

if (-not $SkipHooks) {
    Write-Step 'Creating project hooks.json (user-scope hook paths)'
    $templatePath = Join-Path $RepoRoot 'bundle\cursor\hooks.user.json'
    if (-not (Test-Path $templatePath)) {
        throw "Missing template: $templatePath"
    }
    $hooksHome = ($UserCursor -replace '\\', '/')
    $content = Get-Content $templatePath -Raw
    $content = $content.Replace('{{USER_CURSOR_HOME}}', $hooksHome)
    Set-Content -Path (Join-Path $ProjectCursor 'hooks.json') -Value $content -Encoding UTF8
}

if ($Profile) {
    Write-Step "Applying profile: $Profile"
    $profileRoot = Join-Path $RepoRoot "profiles\$Profile"
    if (-not (Test-Path $profileRoot)) {
        throw "Profile not found: $profileRoot"
    }

    if (Test-Path (Join-Path $profileRoot 'AGENTS.md')) {
        Copy-Item -Force (Join-Path $profileRoot 'AGENTS.md') (Join-Path $ProjectPath 'AGENTS.md')
        Write-Host '  copied AGENTS.md'
    }

    $profileSkills = Join-Path $profileRoot 'skills'
    if (Test-Path $profileSkills) {
        Copy-TreeMerge -Source $profileSkills -Destination (Join-Path $ProjectCursor 'skills') -ForceOverwrite
        Write-Host '  merged profile skills into project .cursor/skills'
    }

    $profileRules = Join-Path $profileRoot 'rules'
    if (Test-Path $profileRules) {
        Copy-TreeMerge -Source $profileRules -Destination (Join-Path $ProjectCursor 'rules') -ForceOverwrite
        Write-Host '  merged profile rules into project .cursor/rules'
    }
}

Write-Step 'Project bootstrap complete'
Write-Host "  Project: $ProjectPath"
Write-Host "  Hooks:   $(Join-Path $ProjectCursor 'hooks.json')"
if (-not $SkipSpecify) {
    Write-Host "  Specify: $(Join-Path $ProjectPath '.specify')"
}
