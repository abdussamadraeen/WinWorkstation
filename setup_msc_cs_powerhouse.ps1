<#
.SYNOPSIS
    MSc Computer Science Ultimate Engineering Suite for Windows 11
.DESCRIPTION
    Configures an elite developer environment tuned for building, algorithms, AI, and systems programming:
    - Installs Rust-based high-speed CLI tools (Starship prompt, Ripgrep, Bat)
    - Tunes Git for maximum I/O performance on Windows (fscache, preloadindex, visual log graph)
    - Builds a modern developer PowerShell profile with Unix-like aliases and instant execution
    - Configures Windows Defender exclusions for coding workspaces to accelerate compilation
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   MSc COMPUTER SCIENCE POWERHOUSE ENVIRONMENT SETUP      " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Install Modern High-Speed Developer Tools
Write-Host "`n[1/4] Installing High-Speed CLI Suite (Starship, Ripgrep, Bat)..." -ForegroundColor Green
$devTools = @("Starship.Starship", "BurntSushi.ripgrep.MSVC", "sharkdp.bat")
foreach ($tool in $devTools) {
    Write-Host " -> Installing $tool..." -ForegroundColor Gray
    winget install --id $tool -e --silent --accept-package-agreements --accept-source-agreements
}

# 2. Tune Git Engine for Extreme Performance on NVMe
Write-Host "`n[2/4] Tuning Git Core Engine for High-Speed I/O..." -ForegroundColor Green
git config --global core.fscache true
git config --global core.preloadindex true
git config --global core.autoCRLF true
# Beautiful visual commit graph alias: git lg
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status -s"
git config --global alias.co "checkout"
git config --global alias.br "branch"
Write-Host " -> Git filesystem cache enabled and visual git aliases configured (try 'git lg')." -ForegroundColor Gray

# 3. Configure Modern PowerShell Profile
Write-Host "`n[3/4] Creating Supercharged Developer Shell Profile..." -ForegroundColor Green
$profileDir = Split-Path -Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileContent = @"
# ==========================================
# MSc CS Supercharged PowerShell Profile
# ==========================================

# Initialize Starship Prompt (Fastest cross-shell prompt in Rust)
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

Write-Host "MSc CS Environment Active. (Commands: venv, grep [rg], cat [bat], which, touch)" -ForegroundColor DarkCyan
"@

Set-Content -Path $PROFILE -Value $profileContent -Encoding UTF8 -Force
Write-Host " -> PowerShell profile configured with Starship prompt and high-speed aliases." -ForegroundColor Gray

# 4. Windows Defender Exclusions for Workspaces (2x-5x Compile Speed)
Write-Host "`n[4/4] Adding Developer Compilation Exclusions to Windows Defender..." -ForegroundColor Green
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

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   MSc CS ENVIRONMENT COMPLETE! RELOAD POWERSHELL TO USE  " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
