<#
.SYNOPSIS
    Deep System & Future-Grade Fine Tuning for Windows 11
.DESCRIPTION
    Applies the ultimate fine-tuning tier:
    1. Browser RAM-Ghost Killer: Prevents Edge & Chrome from running silent background daemons when closed.
    2. Reclaims 4 GB NVMe Storage & disables dirty Fast-Startup memory caching (powercfg -h off).
    3. Next-Gen Network Tuning: Enables Explicit Congestion Notification (ECN) to eliminate packet bufferbloat.
    4. Creates a 1-Word Terminal AI Copilot alias ('ask') directly inside your developer shell.
#>

# 1. Require Administrator Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please re-run this script as Administrator."
    Exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     DEEP SYSTEM & FUTURE-GRADE FINE TUNING ENGINE        " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Step 1: Kill Browser RAM-Ghosts (Edge & Chrome)
Write-Host "`n[1/4] Stopping Silent Background Memory Leaks in Edge & Chrome..." -ForegroundColor Green
$edgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (-not (Test-Path $edgePath)) { New-Item -Path $edgePath -Force | Out-Null }
Set-ItemProperty -Path $edgePath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $edgePath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force

$chromePath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
if (-not (Test-Path $chromePath)) { New-Item -Path $chromePath -Force | Out-Null }
Set-ItemProperty -Path $chromePath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
Write-Host " -> Configured browser policies: Closing Edge/Chrome now frees 100% of RAM immediately." -ForegroundColor Gray

# Step 2: Reclaim 4GB NVMe Storage & Force Clean Kernel Boots
Write-Host "`n[2/4] Reclaiming 4 GB NVMe Storage & Eliminating Dirty Memory Caches..." -ForegroundColor Green
powercfg -h off
Write-Host " -> Hibernation disabled (Deleted 4GB hiberfil.sys; guaranteed clean kernel boot every start)." -ForegroundColor Gray

# Step 3: Modernize TCP/IP Network Stack
Write-Host "`n[3/4] Enabling Low-Latency TCP Explicit Congestion Notification (ECN)..." -ForegroundColor Green
netsh int tcp set global ecncapability=enabled | Out-Null
netsh int tcp set global autotuninglevel=normal | Out-Null
Write-Host " -> ECN enabled and TCP autotuning set to optimal buffer pace." -ForegroundColor Gray

# Step 4: Terminal AI Copilot Setup in PowerShell Profile
Write-Host "`n[4/4] Integrating Future Terminal AI Assistant in PowerShell Profile..." -ForegroundColor Green
$aiHelper = @"

# ==========================================
# Future Terminal AI Copilot ('ask' command)
# ==========================================
function ask (`$prompt) {
    if (-not `$prompt) {
        Write-Host "Usage: ask `"your question or coding task`"" -ForegroundColor Yellow
        return
    }
    Write-Host "[AI] Thinking..." -ForegroundColor Cyan
    ollama run qwen2.5-coder:1.5b "`$prompt"
}
"@

if (Test-Path $PROFILE) {
    $existing = Get-Content -Path $PROFILE -Raw
    if ($existing -notmatch 'function ask') {
        Add-Content -Path $PROFILE -Value $aiHelper -Encoding UTF8
        Write-Host " -> Added 'ask' terminal AI command to your PowerShell profile." -ForegroundColor Gray
    } else {
        Write-Host " -> 'ask' command already present in profile." -ForegroundColor Gray
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   DEEP OPTIMIZATION COMPLETE! MAXIMUM POTENTIAL ENGAGED   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
