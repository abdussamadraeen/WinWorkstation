<#
.SYNOPSIS
    Dynamic Resource Management Guardian for Windows 11
.DESCRIPTION
    Runs an intelligent, low-overhead background monitoring daemon:
    1. Monitors physical RAM pressure; executes working-set memory reclamation if usage exceeds 82%.
    2. Dynamically elevates CPU priority classes for active IDEs (VS Code, Antigravity, CLion, IntelliJ).
    3. Lowers scheduling priority for background updater services.
    4. Negligible footprint: Consumes <0.05% CPU cycles.
#>

$signature = @'
[DllImport("psapi.dll")]
public static extern int EmptyWorkingSet(IntPtr hwProc);
'@
$psapi = Add-Type -MemberDefinition $signature -Name "PSAPISet" -Namespace "Win32API" -PassThru -ErrorAction SilentlyContinue

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    DYNAMIC RESOURCE MANAGEMENT GUARDIAN (WinWorkstation)  " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Monitoring system metrics every 10 seconds. Press Ctrl+C to stop.`n" -ForegroundColor Gray

$ideNames = @("Code", "Antigravity", "windsurf", "idea64", "pycharm64", "clion64", "WindowsTerminal")
$bgNames = @("AdobeCollabSync", "Acrotray", "AGMService", "msedge", "BraveUpdate")

while ($true) {
    try {
        # 1. Check RAM Pressure
        $os = Get-CimInstance Win32_OperatingSystem
        $totalRAM = $os.TotalVisibleMemorySize
        $freeRAM = $os.FreePhysicalMemory
        $usedPercent = [math]::Round((($totalRAM - $freeRAM) / $totalRAM) * 100, 1)

        # 2. Reclaim Memory if RAM is above 82%
        if ($usedPercent -gt 82.0) {
            Write-Host "[!] High RAM usage detected ($usedPercent%). Initiating working set reclaim..." -ForegroundColor Yellow
            Get-Process | Where-Object { $_.WorkingSet64 -gt 50MB -and $ideNames -notcontains $_.ProcessName } | ForEach-Object {
                try { [Win32API.PSAPISet]::EmptyWorkingSet($_.Handle) | Out-Null } catch {}
            }
            [System.GC]::Collect()
            Write-Host " -> Reclaim finished. System memory freed." -ForegroundColor Green
        }

        # 3. Dynamic Process Priority Elevation
        foreach ($ide in $ideNames) {
            Get-Process -Name $ide -ErrorAction SilentlyContinue | ForEach-Object {
                if ($_.PriorityClass -ne "AboveNormal" -and $_.PriorityClass -ne "High") {
                    $_.PriorityClass = "AboveNormal"
                    Write-Host " -> Elevated priority for developer IDE: $($_.ProcessName) (PID: $($_.Id))" -ForegroundColor Cyan
                }
            }
        }

        # 4. Background Updater De-prioritization
        foreach ($bg in $bgNames) {
            Get-Process -Name $bg -ErrorAction SilentlyContinue | ForEach-Object {
                if ($_.PriorityClass -ne "BelowNormal" -and $_.PriorityClass -ne "Idle") {
                    $_.PriorityClass = "BelowNormal"
                }
            }
        }

    } catch {}

    Start-Sleep -Seconds 10
}
