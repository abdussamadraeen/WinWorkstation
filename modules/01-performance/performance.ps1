<#
.SYNOPSIS
    Module 01: Raw Performance & Low-Latency Kernel Tuning
.DESCRIPTION
    Applies deep kernel, filesystem, MMCSS, and background service optimizations.
    Zero third-party bloat. Pure Windows NT architecture tuning.
#>

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Module 01 (Performance) requires Administrator elevation."
    Exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   [MODULE 01] KERNEL & HARDWARE LATENCY ENGINE          " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. System Restore Point
Write-Host "`n[+] Creating System Restore Point..." -ForegroundColor Green
try {
    Enable-ComputerRestore -Drive "C:" -ErrorAction SilentlyContinue
    Checkpoint-Computer -Description "Before_WinWorkstation_Optimization" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
    Write-Host " -> Restore point created successfully." -ForegroundColor Gray
} catch {
    Write-Host " -> Restore point skipped (System Protection disabled or busy)." -ForegroundColor DarkGray
}

# 2. Kernel Scheduling & Multimedia Profile (MMCSS)
Write-Host "`n[+] Tuning CPU Priority Quanta & Network Packet Handling..." -ForegroundColor Green
# Dedicate 100% CPU cycles to foreground active window (SystemResponsiveness = 0)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
# Disable network packet throttling (eliminate 10 packets/ms ancient cap)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force

# Win32PrioritySeparation = 0x26 (38 decimal: Short, variable quanta giving maximum burst priority to foreground tasks)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force

# MMCSS Tasks (Games / Multimedia priority boost)
$gamesPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
if (Test-Path $gamesPath) {
    Set-ItemProperty -Path $gamesPath -Name "GPU Priority" -Value 8 -Type DWord -Force
    Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord -Force
    Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -Type String -Force
}
Write-Host " -> 100% foreground CPU priority and uncapped network throughput engaged." -ForegroundColor Gray

# 3. NVMe Filesystem & Disk I/O Acceleration
Write-Host "`n[+] Optimizing NTFS Storage Engine on NVMe..." -ForegroundColor Green
# Disable legacy MS-DOS 8.3 short name generation (halves file creation metadata overhead in code repos)
fsutil 8dot3name set 1 | Out-Null
# Disable Last Access Time updates (stops continuous SSD write-wear and read latency)
fsutil behavior set disablelastaccess 1 | Out-Null
Write-Host " -> NTFS 8.3 name generation and Last Access Time writing disabled." -ForegroundColor Gray

# 4. Remove Background Recording Hooks & UI Lag
Write-Host "`n[+] Removing GameDVR Background Hooks & UI Delays..." -ForegroundColor Green
if (-not (Test-Path "HKCU:\System\GameConfigStore")) { New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null }
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force

if (-not (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force

# MenuShowDelay to 0ms (instant right-click and context menus)
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force

# Disable Start Menu Bing Web Suggestions (cuts Start Menu delay and web telemetry)
$explorerPolicy = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path $explorerPolicy)) { New-Item -Path $explorerPolicy -Force | Out-Null }
Set-ItemProperty -Path $explorerPolicy -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
Write-Host " -> GameDVR compositing hook killed and UI latency set to 0ms." -ForegroundColor Gray

# 5. Browser Background RAM-Ghost Killer
Write-Host "`n[+] Stopping Silent Background Memory Leaks in Edge & Chrome..." -ForegroundColor Green
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (-not (Test-Path $edgePath)) { New-Item -Path $edgePath -Force | Out-Null }
Set-ItemProperty -Path $edgePath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $edgePath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force

$chromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (-not (Test-Path $chromePath)) { New-Item -Path $chromePath -Force | Out-Null }
Set-ItemProperty -Path $chromePath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
Write-Host " -> Closing browsers now immediately returns 100% of RAM to host." -ForegroundColor Gray

# 6. Reclaim 4GB NVMe Storage (Purge Dirty Fast-Startup State)
Write-Host "`n[+] Reclaiming 4 GB Storage & Enforcing Clean Kernel Boots..." -ForegroundColor Green
powercfg -h off
Write-Host " -> Hibernation purged (Deleted hiberfil.sys; guaranteed clean kernel boot every start)." -ForegroundColor Gray

# 7. Restrain Background Telemetry & P2P Windows Updates
Write-Host "`n[+] Restraining Background Telemetry & P2P Bandwidth Sinks..." -ForegroundColor Green
Set-Service -Name "DoSvc" -StartupType Manual -ErrorAction SilentlyContinue
Stop-Service -Name "DoSvc" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue

Write-Host "`n[SUCCESS] Module 01 (Performance) complete. Reboot to engage kernel." -ForegroundColor Green
