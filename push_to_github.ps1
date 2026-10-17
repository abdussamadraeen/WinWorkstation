<#
.SYNOPSIS
    Automated GitHub Publisher for WinWorkstation
.DESCRIPTION
    Checks GitHub CLI authentication, triggers standard browser sign-in if needed,
    creates the remote repository, and pushes the main branch.
#>

param(
    [string]$RepoName = "WinWorkstation"
)

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       WinWorkstation: GitHub Deployment Engine           " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Check Authentication Status
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] GitHub authentication required." -ForegroundColor Yellow
    Write-Host " -> Launching browser login. Complete the 1-time authorization in your browser..." -ForegroundColor Cyan
    gh auth login --web -p https
}

# 2. Check if remote origin already exists
$hasRemote = git remote
if (-not $hasRemote) {
    Write-Host "`n[+] Creating remote repository and pushing..." -ForegroundColor Green
    gh repo create $RepoName --public --source=. --remote=origin --push --description "Modular Windows 11 Systems Engineering & Workstation Optimization Suite"
} else {
    Write-Host "`n[+] Remote origin exists. Pushing main branch..." -ForegroundColor Green
    git push -u origin main
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   REPOSITORY SUCCESSFULLY PUBLISHED TO GITHUB!           " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
