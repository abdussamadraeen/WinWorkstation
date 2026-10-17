<#
.SYNOPSIS
    Module 03: MSc Computer Science Developer & Systems Suite
.DESCRIPTION
    Configures an elite developer workstation:
    1. Deploys memory-capped .wslconfig (4GB limit, 2 vCPUs, dropcache).
    2. Installs Rust CLI suite: Starship prompt, Ripgrep (rg), Bat (bat), astral-sh uv.
    3. Tunes Git engine for NVMe SSDs (fscache, preloadindex, visual git lg).
    4. Configures PowerShell profile with Unix aliases and terminal AI copilot ('ask').
    5. Adds Windows Defender compilation exclusions for development directories.
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   [MODULE 03] MSc COMPUTER SCIENCE DEVELOPER SUITE       " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. WSL2 / Docker Memory Throttling
Write-Host "`n[+] Deploying Optimized .wslconfig (Stopping Docker RAM Leaks)..." -ForegroundColor Green
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
$wslConfigContent = @"
[wsl2]
memory=4GB
processors=2
autoMemoryReclaim=gradual
localhostForwarding=true

[experimental]
autoMemoryReclaim=dropcache
"@
Set-Content -Path $wslConfigPath -Value $wslConfigContent -Encoding UTF8 -Force
Write-Host " -> .wslconfig deployed: Linux/Docker RAM capped at 4GB with auto-dropcache." -ForegroundColor Gray

# 2. Modern Rust Developer CLI Tools via Winget
Write-Host "`n[+] Installing High-Speed CLI Suite via Winget..." -ForegroundColor Green
$cliTools = @("Starship.Starship", "BurntSushi.ripgrep.MSVC", "sharkdp.bat", "astral-sh.uv")
foreach ($tool in $cliTools) {
    Write-Host " -> Checking $tool..." -ForegroundColor Gray
    winget install --id $tool -e --silent --accept-package-agreements --accept-source-agreements
}

# 3. Git High-Speed Engine Configuration
Write-Host "`n[+] Tuning Git Engine for NVMe SSD Performance..." -ForegroundColor Green
git config --global core.fscache true
git config --global core.preloadindex true
git config --global core.autoCRLF true
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status -s"
git config --global alias.co "checkout"
git config --global alias.br "branch"
Write-Host " -> Git filesystem cache enabled. Visual log graph configured ('git lg')." -ForegroundColor Gray

# 4. Developer Shell Profile Configuration
Write-Host "`n[+] Configuring Supercharged Developer Shell Profile..." -ForegroundColor Green
$profileDir = Split-Path -Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileContent = @"
# ==========================================
# MSc CS Supercharged PowerShell Profile
# ==========================================

# Initialize Starship Prompt (Rust-based prompt)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# High-Speed Unix Aliases
Set-Alias -Name grep -Value rg -Option AllScope -ErrorAction SilentlyContinue
Set-Alias -Name cat  -Value bat -Option AllScope -ErrorAction SilentlyContinue

function touch (`$file) {
    New-Item -ItemType File -Name `$file -Force | Out-Null
}

function which (`$cmd) {
    (Get-Command `$cmd -ErrorAction SilentlyContinue).Source
}

# Fast Python Virtualenv Activator
function venv {
    if (Test-Path ".\.venv\Scripts\Activate.ps1") {
        .\.venv\Scripts\Activate.ps1
    } elseif (Test-Path ".\venv\Scripts\Activate.ps1") {
        .\venv\Scripts\Activate.ps1
    } else {
        Write-Host "Creating optimized virtualenv with uv..." -ForegroundColor Cyan
        uv venv
        .\.venv\Scripts\Activate.ps1
    }
}

# Terminal AI Copilot
function ask (`$prompt) {
    if (-not `$prompt) {
        Write-Host "Usage: ask `"your question or coding task`"" -ForegroundColor Yellow
        return
    }
    Write-Host "[AI] Thinking..." -ForegroundColor Cyan
    ollama run qwen2.5-coder:1.5b "`$prompt"
}

Write-Host "MSc CS Environment Active. (Commands: venv, grep [rg], cat [bat], which, touch, ask)" -ForegroundColor DarkCyan
"@

Set-Content -Path $PROFILE -Value $profileContent -Encoding UTF8 -Force
Write-Host " -> PowerShell profile updated with Starship prompt, Unix aliases, and 'ask' AI command." -ForegroundColor Gray

# 5. Developer Compilation Exclusions in Windows Defender
Write-Host "`n[+] Adding Developer Compilation Exclusions to Windows Defender..." -ForegroundColor Green
$workspacePaths = @(
    "D:\WindowsMacStyleBackup",
    "$env:USERPROFILE\.cargo",
    "$env:USERPROFILE\.rustup",
    "$env:USERPROFILE\.m2",
    "$env:USERPROFILE\.gradle"
)

foreach ($p in $workspacePaths) {
    if (Test-Path $p) {
        try {
            Add-MpPreference -ExclusionPath $p -ErrorAction SilentlyContinue
            Write-Host " -> Excluded: $p" -ForegroundColor Gray
        } catch {}
    }
}

Write-Host "`n[SUCCESS] Module 03 (Developer Suite) complete." -ForegroundColor Green
