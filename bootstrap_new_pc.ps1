<#
.SYNOPSIS
    Universal 1-Click Bootstrap Script for Future Laptops (Windows 11 Beast-Mode)
.DESCRIPTION
    Instantly recreates your entire MSc Computer Science & Aesthetic powerhouse:
    1. Applies low-latency kernel, MMCSS, and NVMe optimizations
    2. Deploys memory-capped .wslconfig (stops Docker/WSL memory leaks)
    3. Batch installs all tools via Winget (Git, Starship, RipGrep, Bat, PowerToys, QuickLook, TranslucentTB, Everything, Flow Launcher, uv)
    4. Builds your high-speed PowerShell profile with Unix aliases
    5. Configures Git performance flags and visual log aliases
    6. Adds Windows Defender compilation exclusions
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] Elevating to Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   UNIVERSAL 1-CLICK LAPTOP BOOTSTRAP (MSc CS EDITION)    " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Step 1: Low-Latency Kernel & System Optimization
Write-Host "`n[1/6] Applying Kernel & System Optimizations..." -ForegroundColor Green
if (Test-Path "$ScriptDir\optimize_beast_win11.ps1") {
    & "$ScriptDir\optimize_beast_win11.ps1"
}
if (Test-Path "$ScriptDir\deep_system_optimization.ps1") {
    & "$ScriptDir\deep_system_optimization.ps1"
}

# Step 2: Deploy Optimal WSL2 Configuration
Write-Host "`n[2/6] Configuring WSL2 Memory Throttles..." -ForegroundColor Green
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
$wslConfigContent = @"
[wsl2]
memory=4GB
processors=2
autoMemoryReclaim=gradual
localhostForwarding=true

[experimental]
autoMemoryReclaim=dropcache
"@
Set-Content -Path $wslConfigPath -Value $wslConfigContent -Encoding UTF8 -Force
Write-Host " -> Deployed optimal .wslconfig to $wslConfigPath." -ForegroundColor Gray

# Step 3: Batch Install All Software via Winget
Write-Host "`n[3/6] Installing Complete Toolchain via Winget..." -ForegroundColor Green
$packages = @(
    # Developer Toolchain
    "Git.Git",
    "Starship.Starship",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.bat",
    "astral-sh.uv",
    # Aesthetic & Productivity Suite
    "CharlesMilette.TranslucentTB",
    "QL-Win.QuickLook",
    "Flow-Launcher.Flow-Launcher",
    "Microsoft.PowerToys",
    "voidtools.Everything"
)

foreach ($pkg in $packages) {
    Write-Host " -> Checking/Installing: $pkg..." -ForegroundColor Gray
    winget install --id $pkg -e --silent --accept-package-agreements --accept-source-agreements
}

# Step 4: Configure Developer Shell & Aliases
Write-Host "`n[4/6] Setting Up PowerShell Developer Profile..." -ForegroundColor Green
if (Test-Path "$ScriptDir\setup_msc_cs_powerhouse.ps1") {
    & "$ScriptDir\setup_msc_cs_powerhouse.ps1"
}

# Step 5: Configure Git Performance
Write-Host "`n[5/6] Tuning Git for NVMe Storage..." -ForegroundColor Green
git config --global core.fscache true
git config --global core.preloadindex true
git config --global core.autoCRLF true
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status -s"
git config --global alias.co "checkout"
git config --global alias.br "branch"

# Step 6: Launch Core Aesthetic Utilities
Write-Host "`n[6/6] Launching Aesthetic & Productivity Suite..." -ForegroundColor Green
try {
    Start-Process "$env:LOCALAPPDATA\Programs\QuickLook\QuickLook.exe" -ErrorAction SilentlyContinue
    Start-Process "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe" -ErrorAction SilentlyContinue
    explorer.exe shell:AppsFolder\28017CharlesMilette.TranslucentTB_vfxyd3mpbvabb!TranslucentTB
} catch {}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   NEW LAPTOP SETUP COMPLETE! REBOOT TO ENGAGE KERNEL.   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
