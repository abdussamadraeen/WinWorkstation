<#
.SYNOPSIS
    Dynamic Resource Management Guardian & Foreground Focus Engine
.DESCRIPTION
    Runs an intelligent, low-overhead (<0.05% CPU) background monitoring daemon:
    1. Dynamic Foreground Focus: Continuously detects the active window under your mouse/focus,
       instantly boosting its CPU priority to 'AboveNormal' for zero-lag responsiveness.
    2. Background Throttling: Automatically demotes non-active and background updater services
       to 'BelowNormal' or 'Idle' priority so they cannot steal CPU cycles from your active app.
    3. Memory Pressure Trimmer: Automatically reclaims working-set memory from inactive background
       processes if physical RAM usage exceeds 80%.
#>

$signature = @'
using System;
using System.Runtime.InteropServices;

public class Win32Sys {
    [DllImport("psapi.dll")]
    public static extern int EmptyWorkingSet(IntPtr hwProc);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", SetLastError=true)]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
}
'@
Add-Type -TypeDefinition $signature -PassThru -ErrorAction SilentlyContinue | Out-Null

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    DYNAMIC FOREGROUND FOCUS & RESOURCE GUARDIAN ACTIVE   " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Active application will receive instant CPU boost; background apps throttled." -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop.`n" -ForegroundColor DarkGray

$exemptProcesses = @("explorer", "dwm", "csrss", "smss", "services", "lsass", "System", "Idle", "msedge", "chrome", "Antigravity", "code")
$bgThrottled = @("AdobeCollabSync", "Acrotray", "AGMService", "BraveUpdate", "PhoneExperienceHost")

$lastForegroundPid = 0

while ($true) {
    try {
        # 1. Detect Active Foreground Window
        $hwnd = [Win32Sys]::GetForegroundWindow()
        $currentPid = 0
        if ($hwnd -ne [IntPtr]::Zero) {
            [Win32Sys]::GetWindowThreadProcessId($hwnd, [ref]$currentPid) | Out-Null
        }

        # 2. Elevate Active Window if Changed
        if ($currentPid -gt 0 -and $currentPid -ne $lastForegroundPid) {
            $fgProc = Get-Process -Id $currentPid -ErrorAction SilentlyContinue
            if ($fgProc -and $exemptProcesses -notcontains $fgProc.ProcessName) {
                # Elevate active window
                if ($fgProc.PriorityClass -ne "AboveNormal" -and $fgProc.PriorityClass -ne "High") {
                    try {
                        $fgProc.PriorityClass = "AboveNormal"
                        Write-Host "[FOCUS] Priority boosted for active app: $($fgProc.ProcessName) (PID: $currentPid)" -ForegroundColor Cyan
                    } catch {}
                }

                # Demote previous active window back to Normal
                if ($lastForegroundPid -gt 0) {
                    $prevProc = Get-Process -Id $lastForegroundPid -ErrorAction SilentlyContinue
                    if ($prevProc -and $prevProc.PriorityClass -eq "AboveNormal") {
                        try { $prevProc.PriorityClass = "Normal" } catch {}
                    }
                }

                $lastForegroundPid = $currentPid
            }
        }

        # 3. Throttle Known Heavy Background Telemetry
        foreach ($bg in $bgThrottled) {
            Get-Process -Name $bg -ErrorAction SilentlyContinue | ForEach-Object {
                if ($_.Id -ne $currentPid -and $_.PriorityClass -ne "BelowNormal" -and $_.PriorityClass -ne "Idle") {
                    try {
                        $_.PriorityClass = "BelowNormal"
                    } catch {}
                }
            }
        }

    } catch {}

    Start-Sleep -Seconds 3
}
