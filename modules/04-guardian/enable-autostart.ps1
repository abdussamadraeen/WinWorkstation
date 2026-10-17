<#
.SYNOPSIS
    Enables Silent Background Auto-Start for the WinWorkstation Guardian Daemon
.DESCRIPTION
    Creates a silent Windows Startup shortcut pointing to start-guardian-silent.vbs.
    Runs completely invisibly in the background on every boot with 0% visible console.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$vbsPath = "$ScriptDir\start-guardian-silent.vbs"
$startupFolder = [System.Environment]::GetFolderPath("Startup")
$shortcutPath = "$startupFolder\WinWorkstation-Guardian.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$vbsPath`""
$Shortcut.WorkingDirectory = $ScriptDir
$Shortcut.Description = "WinWorkstation Dynamic Foreground Focus & Memory Guardian"
$Shortcut.Save()

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   WINWORKSTATION GUARDIAN AUTO-START ENABLED             " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Guardian will now run completely invisibly on every boot." -ForegroundColor Gray
Write-Host "Shortcut created: $shortcutPath`n" -ForegroundColor DarkGray
