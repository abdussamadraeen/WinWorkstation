<#
.SYNOPSIS
    Peak Performance & Low-Latency Engine for Windows 11 (Tailored for AMD Ryzen + NVMe)
.DESCRIPTION
    Applies deep kernel, filesystem, MMCSS, DPC latency, and background service optimizations.
    Includes safety checks and creates a system restore point prior to execution.
#>

# 1. Require Administrator Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please re-run this script as Administrator (Right click PowerShell -> Run as Administrator)."
    Exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   WINDOWS 11 BEAST-MODE KERNEL & PERFORMANCE OPTIMIZER   " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 2. Create System Restore Point for Total Safety
Write-Host "`n[1/6] Creating System Restore Point..." -ForegroundColor Green
try {
    Enable-ComputerRestore -Drive "C:" -ErrorAction SilentlyContinue
    Checkpoint-Computer -Description "Before_Beast_Mode_Optimization" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
    Write-Host " -> Restore point successfully created." -ForegroundColor Gray
} catch {
    Write-Host " -> Restore point skipped (System Protection disabled or busy)." -ForegroundColor DarkGray
}

# 3. Kernel & CPU Prioritization (Foreground Boost & Latency)
Write-Host "`n[2/6] Tuning CPU Scheduling, MMCSS & Network Latency..." -ForegroundColor Green

# Dedicate 100% CPU to foreground interactive threads (SystemResponsiveness = 0)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
# Disable network packet throttling (eliminate packet queueing lag)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force

# Optimize MMCSS Gaming/Multimedia priority
$gamesPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if (Test-Path $gamesPath) {
    Set-ItemProperty -Path $gamesPath -Name "GPU Priority" -Value 8 -Type DWord -Force
    Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord -Force
    Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -Type String -Force
}

# Win32PrioritySeparation = 0x26 (38 decimal: Short, variable quanta giving maximum burst priority to foreground windows)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force
Write-Host " -> Foreground thread boost & network packet throttling removed." -ForegroundColor Gray

# 4. Storage & Filesystem (NVMe Optimization)
Write-Host "`n[3/6] Tuning NTFS Filesystem & NVMe I/O Performance..." -ForegroundColor Green

# Disable NTFS 8.3 legacy DOS short name creation (dramatically speeds up folder operations in Git/Node/Apps)
fsutil 8dot3name set 1 | Out-Null

# Disable Last Access Time updating (eliminates unnecessary disk writes every time a file is read)
fsutil behavior set disablelastaccess 1 | Out-Null
Write-Host " -> Disabled NTFS 8.3 legacy generation and Last Access Time writing." -ForegroundColor Gray

# 5. Disable GameDVR Background Hook & UI Input Delays
Write-Host "`n[4/6] Disabling GameDVR Recording Hooks & Input Lag..." -ForegroundColor Green

# Disable GameDVR background hooks
if (-not (Test-Path "HKCU:\System\GameConfigStore")) { New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null }
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force

# MenuShowDelay to 0 (Zero right-click/flyout delay)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force

# Disable Start Menu Bing Search (cuts Start Menu delay and web telemetry)
$explorerPolicy = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path $explorerPolicy)) { New-Item -Path $explorerPolicy -Force | Out-Null }
Set-ItemProperty -Path $explorerPolicy -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
Write-Host " -> GameDVR polling killed and menu delays set to 0ms." -ForegroundColor Gray

# 6. Service & Telemetry Optimization
Write-Host "`n[5/6] Tuning Resource-Draining Background Services..." -ForegroundColor Green

# Delivery Optimization (P2P Windows update bandwidth & CPU consumption)
Set-Service -Name "DoSvc" -StartupType Manual -ErrorAction SilentlyContinue
Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue

# Diagnostic Tracking (Telemetry)
Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue

# Disable Windows Feedback prompts
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host " -> Background peer-to-peer and telemetry services restrained." -ForegroundColor Gray

# 7. Add Windows Defender Developer Exclusion for Current Drive/Workspace
Write-Host "`n[6/6] Accelerating Local Development Workspaces in Windows Defender..." -ForegroundColor Green
try {
    Add-MpPreference -ExclusionPath "D:\WindowsMacStyleBackup" -ErrorAction SilentlyContinue
    Write-Host " -> Added exclusion for D:\WindowsMacStyleBackup (Prevents MsMpEng CPU spikes during file operations)." -ForegroundColor Gray
} catch {
    Write-Host " -> Defender exclusion requires administrative session." -ForegroundColor DarkGray
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   OPTIMIZATION COMPLETE! PLEASE REBOOT TO ENGAGE KERNEL   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
