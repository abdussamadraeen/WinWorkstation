<#
.SYNOPSIS
    Windows 11 Beast-Mode Master Orchestrator
.DESCRIPTION
    Modular orchestrator allowing selective or full execution of:
    - Module 01: Raw Performance & Low Latency Kernel Engine
    - Module 02: Aesthetics, Smoothness & Futuristic Look
    - Module 03: MSc Computer Science Developer & Systems Suite
    - Module 04: Autonomous OS Guardian & Memory Manager
.PARAMETER All
    Applies Modules 01, 02, and 03 in one shot.
.PARAMETER Performance
    Applies only Module 01 (Performance).
.PARAMETER Aesthetics
    Applies only Module 02 (Aesthetics).
.PARAMETER Developer
    Applies only Module 03 (Developer Suite).
.PARAMETER Guardian
    Launches Module 04 (Autonomous Watchdog).
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
    Write-Host "[*] Elevating to Administrator..." -ForegroundColor Yellow
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

# Interactive Menu if no switch provided
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       WINDOWS 11 BEAST-MODE MASTER ORCHESTRATOR          " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Select which module you want to execute:`n" -ForegroundColor Gray
Write-Host " [1] Full Beast Mode (Performance + Aesthetics + Developer)" -ForegroundColor White
Write-Host " [2] Raw Performance & Kernel Latency Only (Module 01)" -ForegroundColor White
Write-Host " [3] Aesthetics & Futuristic Glass Look Only (Module 02)" -ForegroundColor White
Write-Host " [4] MSc CS Developer & Systems Suite Only (Module 03)" -ForegroundColor White
Write-Host " [5] Launch Autonomous OS Guardian Watchdog (Module 04)" -ForegroundColor White
Write-Host " [Q] Quit`n" -ForegroundColor DarkGray

$choice = Read-Host "Enter selection [1-5, Q]"

switch ($choice) {
    "1" { Run-Performance; Run-Aesthetics; Run-Developer }
    "2" { Run-Performance }
    "3" { Run-Aesthetics }
    "4" { Run-Developer }
    "5" { Run-Guardian }
    "Q" { Write-Host "Exiting." -ForegroundColor Gray; Exit }
    default { Write-Warning "Invalid choice. Exiting." }
}
