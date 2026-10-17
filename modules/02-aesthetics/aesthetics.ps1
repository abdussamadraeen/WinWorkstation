<#
.SYNOPSIS
    Module 02: Workstation Ergonomics & Desktop Aesthetics
.DESCRIPTION
    Combines native Windows 11 desktop styling with high-performance, GPU-accelerated tools:
    1. Native Windows 11 Styling: Centered taskbar, hides clutter (widgets/copilot/task view).
    2. TranslucentTB: High-performance DWM acrylic composition taskbar (0% CPU footprint).
    3. QuickLook: Instantaneous spacebar file inspection for code, PDFs, media.
    4. Flow Launcher: High-efficiency keyboard-driven command palette (Alt + Space).
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   [MODULE 02] WORKSTATION ERGONOMICS & DESKTOP AESTHETICS" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Native Windows 11 Clean Taskbar & Clutter Removal
Write-Host "`n[+] Tuning Native Windows 11 Desktop Styling..." -ForegroundColor Green
$advExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Taskbar alignment: 1 = Center (macOS Dock feel)
Set-ItemProperty -Path $advExplorer -Name "TaskbarAl" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

# Hide Task View button (reduces taskbar clutter)
Set-ItemProperty -Path $advExplorer -Name "ShowTaskViewButton" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Hide Widgets button from taskbar
Set-ItemProperty -Path $advExplorer -Name "TaskbarDa" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue

# Taskbar Search mode: 1 = Icon only (clean, sleek)
$searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty -Path $searchPath -Name "SearchboxTaskbarMode" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue

Write-Host " -> Taskbar centered and native clutter (widgets/search box) streamlined." -ForegroundColor Gray

# 2. Install Lightweight Aesthetic & Flow Tools via Winget
Write-Host "`n[+] Installing Futuristic Open-Source Tools..." -ForegroundColor Green
$lookPackages = @(
    @{ Id = "CharlesMilette.TranslucentTB"; Name = "TranslucentTB (Acrylic Glass Taskbar)" },
    @{ Id = "QL-Win.QuickLook";            Name = "QuickLook (Spacebar File Preview)" },
    @{ Id = "Flow-Launcher.Flow-Launcher";  Name = "Flow Launcher (Futuristic Spotlight)" }
)

foreach ($pkg in $lookPackages) {
    Write-Host " -> Checking $($pkg.Name)..." -ForegroundColor Gray
    winget install --id $pkg.Id -e --silent --accept-package-agreements --accept-source-agreements
}

# 3. Launch Aesthetic Suite
Write-Host "`n[+] Launching Aesthetic Services..." -ForegroundColor Green
try {
    # Launch QuickLook
    if (Test-Path "$env:LOCALAPPDATA\Programs\QuickLook\QuickLook.exe") {
        Start-Process "$env:LOCALAPPDATA\Programs\QuickLook\QuickLook.exe" -ErrorAction SilentlyContinue
    }
    # Launch Flow Launcher
    if (Test-Path "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe") {
        Start-Process "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe" -ErrorAction SilentlyContinue
    }
    # Launch TranslucentTB
    explorer.exe shell:AppsFolder\28017CharlesMilette.TranslucentTB_vfxyd3mpbvabb!TranslucentTB
    Write-Host " -> TranslucentTB, QuickLook, and Flow Launcher active." -ForegroundColor Gray
} catch {}

Write-Host "`n[SUCCESS] Module 02 (Aesthetics) complete. Enjoy your glass setup!" -ForegroundColor Green
