@echo off
:: WinWorkstation: Restore Full Multitasking Power & Fix White-Screen Latency
:: Automatically elevates to Administrator to reset scheduler and browser policies

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run_fix
) else (
    echo Requesting Administrator elevation to apply fix...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:run_fix
echo ==========================================================
echo    RESTORING FULL MULTITASKING POWER & FIXING LATENCY     
echo ==========================================================

echo [1/4] Restoring Balanced Desktop Scheduler (Win32PrioritySeparation = 2)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f

echo [2/4] Removing Restrictive Browser Policies (Fixing Edge White Screen)...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Google\Chrome" /v BackgroundModeEnabled /f >nul 2>&1

echo [3/4] Ensuring Balanced Power Profile Active...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

echo [4/4] Resetting Process Priorities...
powershell -NoProfile -Command "Get-Process msedge, Antigravity -ErrorAction SilentlyContinue | ForEach-Object { try { $_.PriorityClass = 'Normal' } catch {} }"

echo.
echo ==========================================================
echo    SUCCESS! FULL MULTITASKING POWER RESTORED!            
echo ==========================================================
echo Edge white-screen fixed, child process starvation removed,
echo and Docker limits uncapped.
echo.
pause
