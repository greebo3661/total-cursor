#Requires -Version 7.0
<#
.SYNOPSIS
  Install total-cursor bundle to user-scope Cursor directory (~/.cursor).
.PARAMETER Overwrite
  Overwrite existing skills/rules/agents/hooks instead of skip-if-exists merge.
.PARAMETER SkipMcp
  Do not create or merge mcp.json.
.PARAMETER SkipHooks
  Skip hooks installation.
#>
[CmdletBinding()]
param(
    [switch]$Overwrite,
    [switch]$SkipMcp,
    [switch]$SkipHooks
)

$ErrorActionPreference = 'Stop'
$RepoRoot = $PSScriptRoot
$BundleCursor = Join-Path $RepoRoot 'bundle\cursor'
$UserCursor = Join-Path $env:USERPROFILE '.cursor'

function Test-CommandExists([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Write-Step([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Copy-TreeMerge {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$ForceOverwrite
    )
    if (-not (Test-Path $Source)) {
        throw "Missing bundle path: $Source"
    }
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    Get-ChildItem $Source -Force | ForEach-Object {
        $target = Join-Path $Destination $_.Name
        if ($_.PSIsContainer) {
            Copy-TreeMerge -Source $_.FullName -Destination $target -ForceOverwrite:$ForceOverwrite
        }
        elseif ($ForceOverwrite -or -not (Test-Path $target)) {
            Copy-Item -Force $_.FullName $target
        }
    }
}

function Merge-McpConfig {
    param(
        [string]$ExamplePath,
        [string]$TargetPath
    )
    if (-not (Test-Path $ExamplePath)) { return }
    $example = Get-Content $ExamplePath -Raw | ConvertFrom-Json
    $merged = [ordered]@{ mcpServers = [ordered]@{} }

    if (Test-Path $TargetPath) {
        $existing = Get-Content $TargetPath -Raw | ConvertFrom-Json
        if ($existing.mcpServers) {
            foreach ($prop in $existing.mcpServers.PSObject.Properties) {
                $merged.mcpServers[$prop.Name] = $prop.Value
            }
        }
    }

    foreach ($prop in $example.mcpServers.PSObject.Properties) {
        $name = $prop.Name
        if (-not $merged.mcpServers.Contains($name)) {
            $merged.mcpServers[$name] = $prop.Value
            continue
        }
        $current = $merged.mcpServers[$name]
        $incoming = $prop.Value
        if ($current.env -and $incoming.env) {
            foreach ($envProp in $incoming.env.PSObject.Properties) {
                $key = $envProp.Name
                $val = [string]$current.env.$key
                if ([string]::IsNullOrWhiteSpace($val) -or $val -eq 'YOUR_TOKEN_HERE') {
                    if (-not $current.env.PSObject.Properties[$key]) {
                        Add-Member -InputObject $current.env -NotePropertyName $key -NotePropertyValue $envProp.Value
                    }
                    else {
                        $current.env.$key = $envProp.Value
                    }
                }
            }
        }
    }

    $json = $merged | ConvertTo-Json -Depth 10
    Set-Content -Path $TargetPath -Value $json -Encoding UTF8
}

Write-Step 'Checking prerequisites'
foreach ($cmd in @('git', 'node')) {
    if (-not (Test-CommandExists $cmd)) {
        throw "Required command not found: $cmd"
    }
}
if (-not (Test-Path $BundleCursor)) {
    throw "Bundle not found at $BundleCursor"
}

Write-Step "Installing to $UserCursor"
New-Item -ItemType Directory -Force -Path $UserCursor | Out-Null

Write-Step 'Skills'
Copy-TreeMerge -Source (Join-Path $BundleCursor 'skills') -Destination (Join-Path $UserCursor 'skills') -ForceOverwrite:$Overwrite

Write-Step 'Agents'
Copy-TreeMerge -Source (Join-Path $BundleCursor 'agents') -Destination (Join-Path $UserCursor 'agents') -ForceOverwrite:$Overwrite

Write-Step 'Rules'
Copy-TreeMerge -Source (Join-Path $BundleCursor 'rules') -Destination (Join-Path $UserCursor 'rules') -ForceOverwrite:$Overwrite

if (-not $SkipHooks) {
    Write-Step 'Hooks'
    Copy-TreeMerge -Source (Join-Path $BundleCursor 'hooks') -Destination (Join-Path $UserCursor 'hooks') -ForceOverwrite:$Overwrite
}

if (-not $SkipMcp) {
    Write-Step 'MCP config (merge)'
    Merge-McpConfig -ExamplePath (Join-Path $BundleCursor 'mcp.json.example') -TargetPath (Join-Path $UserCursor 'mcp.json')
}

Write-Step 'Done'
$skills = (Get-ChildItem (Join-Path $UserCursor 'skills') -Directory -ErrorAction SilentlyContinue).Count
$rules = (Get-ChildItem (Join-Path $UserCursor 'rules') -File -ErrorAction SilentlyContinue).Count
$agents = (Get-ChildItem (Join-Path $UserCursor 'agents') -File -ErrorAction SilentlyContinue).Count
Write-Host "Installed/merged at $UserCursor"
Write-Host "  skills: $skills"
Write-Host "  rules:  $rules"
Write-Host "  agents: $agents"
Write-Host ''
Write-Host 'Next steps:'
Write-Host '  1. Restart Cursor'
Write-Host '  2. Set GITHUB_PERSONAL_ACCESS_TOKEN in %USERPROFILE%\.cursor\mcp.json'
Write-Host '  3. Run bootstrap-project.ps1 for project hooks and .specify'
Write-Host '  4. Run verify.ps1'
