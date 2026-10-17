@echo off
:: Windows 11 Beast-Mode Master Launcher
:: Elevates to Administrator automatically and runs main.ps1

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run_powershell
) else (
    echo Elevating to Administrator...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:run_powershell
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0main.ps1"
pause
