<#
.SYNOPSIS
    WinWorkstation: Master Orchestration Engine
.DESCRIPTION
    Modular orchestrator providing automated deployment and configuration of:
    - Module 01: Kernel & Hardware Performance Optimization
    - Module 02: Workstation Ergonomics & Desktop Aesthetics
    - Module 03: Software Engineering & Systems Toolchain
    - Module 04: Dynamic Resource Management Guardian
.PARAMETER All
    Deploys Modules 01, 02, and 03 in sequence.
.PARAMETER Performance
    Executes Module 01 (Kernel & Storage Optimization).
.PARAMETER Aesthetics
    Executes Module 02 (Workstation Ergonomics).
.PARAMETER Developer
    Executes Module 03 (Developer & Systems Toolchain).
.PARAMETER Guardian
    Launches Module 04 (Autonomous Resource Guardian).
#>

[CmdletBinding()]
param(
    [switch]$All,
    [switch]$Performance,
    [switch]$Aesthetics,
    [switch]$Developer,
    [switch]$Guardian
)

# Elevate to Administrator if not already elevated
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] Requesting Administrator elevation..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Run-Performance {
    & "$ScriptDir\modules\01-performance\performance.ps1"
}

function Run-Aesthetics {
    & "$ScriptDir\modules\02-aesthetics\aesthetics.ps1"
}

function Run-Developer {
    & "$ScriptDir\modules\03-developer\developer.ps1"
}

function Run-Guardian {
    & "$ScriptDir\modules\04-guardian\os-guardian.ps1"
}

# Parameter dispatch
if ($All) {
    Run-Performance
    Run-Aesthetics
    Run-Developer
    Exit
}
if ($Performance) { Run-Performance; Exit }
if ($Aesthetics)  { Run-Aesthetics; Exit }
if ($Developer)   { Run-Developer; Exit }
if ($Guardian)    { Run-Guardian; Exit }

# Interactive Terminal UI
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       WinWorkstation: Master Orchestration Engine        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Select subsystem deployment option:`n" -ForegroundColor Gray
Write-Host " [1] Full Workstation Suite (Performance + Ergonomics + Developer)" -ForegroundColor White
Write-Host " [2] Kernel Latency & Hardware Optimization (Module 01)" -ForegroundColor White
Write-Host " [3] Workstation Ergonomics & Aesthetics (Module 02)" -ForegroundColor White
Write-Host " [4] Software Engineering & Systems Toolchain (Module 03)" -ForegroundColor White
Write-Host " [5] Autonomous Resource Management Watchdog (Module 04)" -ForegroundColor White
Write-Host " [Q] Quit`n" -ForegroundColor DarkGray

$choice = Read-Host "Enter selection [1-5, Q]"

switch ($choice) {
    "1" { Run-Performance; Run-Aesthetics; Run-Developer }
    "2" { Run-Performance }
    "3" { Run-Aesthetics }
    "4" { Run-Developer }
    "5" { Run-Guardian }
    "Q" { Write-Host "Exited." -ForegroundColor Gray; Exit }
    default { Write-Warning "Invalid selection. Exiting." }
}
