<#
.SYNOPSIS
    Disables Auto-Start for the WinWorkstation Guardian Daemon
#>

$startupFolder = [System.Environment]::GetFolderPath("Startup")
$shortcutPath = "$startupFolder\WinWorkstation-Guardian.lnk"

if (Test-Path $shortcutPath) {
    Remove-Item $shortcutPath -Force
    Write-Host "[+] Removed WinWorkstation Guardian from Windows Startup." -ForegroundColor Green
} else {
    Write-Host "[*] Guardian is not currently configured for startup." -ForegroundColor Yellow
}
