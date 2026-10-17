<#
.SYNOPSIS
    Installs the Next-Gen Windows 11 Aesthetic, Smoothness & Productivity Arsenal
.DESCRIPTION
    Installs 100% free and open-source utilities via Winget:
    - TranslucentTB: Pure glass / acrylic dynamic taskbar
    - QuickLook: Instant macOS-style Spacebar preview for all files
    - Flow Launcher: Futuristic Spotlight/Raycast command palette
    - Microsoft PowerToys: FancyZones window tiling, OCR, Pin on Top
    - Everything (Voidtools): Sub-millisecond instant search
    - Lively Wallpaper: GPU-accelerated fluid/dynamic wallpapers (auto-pausing)
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   INSTALLING FUTURE AESTHETICS & SMOOTHNESS PACK         " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$packages = @(
    @{ Id = "CharlesMilette.TranslucentTB"; Name = "TranslucentTB (Glass Taskbar)" },
    @{ Id = "QL-Win.QuickLook";            Name = "QuickLook (Spacebar File Preview)" },
    @{ Id = "Flow-Launcher.Flow-Launcher";  Name = "Flow Launcher (Futuristic Spotlight)" },
    @{ Id = "Microsoft.PowerToys";         Name = "PowerToys (FancyZones, OCR, Pin on Top)" },
    @{ Id = "voidtools.Everything";        Name = "Everything (0.001s Instant File Search)" },
    @{ Id = "rocksdanister.Lively";        Name = "Lively Wallpaper (Interactive Visuals)" }
)

foreach ($pkg in $packages) {
    Write-Host "`n[+] Installing $($pkg.Name)..." -ForegroundColor Green
    winget install --id $pkg.Id -e --silent --accept-package-agreements --accept-source-agreements
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   ALL PACKAGES INSTALLED! ENJOY YOUR NEXT-GEN WORKSPACE   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
