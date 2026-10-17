@echo off
:: WinWorkstation: Administrative Bootstrap Launcher
:: Evaluates elevation status, elevates if necessary, and executes main.ps1

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run_powershell
) else (
    echo Requesting Administrator elevation...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:run_powershell
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0main.ps1"
pause
