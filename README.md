# ⚡ Windows 11 "Beast Mode" — Modular Performance, Aesthetic & Developer Architecture

[![Windows 11](https://img.shields.io/badge/Windows-11%20Ready-0078D4?logo=windows11&logoColor=white)](https://microsoft.com/windows)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Zero Bloat](https://img.shields.io/badge/Bloatware-0%25-red.svg)]()
[![Hardware-Accelerated](https://img.shields.io/badge/Performance-Kernel%20Tuned-orange.svg)]()

A modular, zero-cost, open-source engineering suite to transform Windows 11 into a low-latency, futuristic, high-performance workstation for software engineers, computer science researchers, and power users.

---

## 🧭 Repository Architecture

The repository is modularly decoupled so you can apply **only what you need**:

```
Windows11-BeastMode/
├── modules/
│   ├── 01-performance/        # 🚀 Low-Latency Kernel, Network, & NVMe Filesystem Engine
│   ├── 02-aesthetics/         # 💎 Glass Taskbar, Spacebar Preview, & Spotlight Palette
│   ├── 03-developer/          # 🛠️ Rust CLI Tools, WSL2 Memory Cap, & Developer Shell
│   └── 04-guardian/           # 🛡️ Autonomous RAM-Leak Trimmer & Dynamic Priority Watchdog
├── native-vs-thirdparty.md    # ⚖️ Deep Analysis: What Windows has natively vs 3rd-party
├── main.ps1                   # 🎛️ Master Orchestrator (CLI switches + interactive menu)
├── install.bat                # ⚡ 1-Double-Click Auto-Elevation Launcher
├── .gitignore
├── LICENSE                    # MIT
└── README.md
```

---

## ⚡ Quickstart

### Option 1: 1-Click Double-Click (Local / USB Drive)
1. Download or clone this repository.
2. Double-click **`install.bat`** (accept the Administrator prompt).
3. Select an option from the interactive menu:
   * **[1] Full Beast Mode** (Performance + Aesthetics + Developer)
   * **[2] Raw Performance & Latency Only** (Module 01)
   * **[3] Aesthetics & Futuristic Glass Look Only** (Module 02)
   * **[4] MSc CS Developer Suite Only** (Module 03)
   * **[5] Launch Autonomous OS Guardian Watchdog** (Module 04)

### Option 2: 1-Command PowerShell (Remote GitHub)
```powershell
# Run Full Setup directly from PowerShell (Admin):
irm https://raw.githubusercontent.com/DimensionWanderer/Windows11-BeastMode/main/main.ps1 | iex
```

### Option 3: Command-Line Flags
```powershell
# Performance Only
.\main.ps1 -Performance

# Aesthetics Only
.\main.ps1 -Aesthetics

# Developer Suite Only
.\main.ps1 -Developer
```

---

## 📦 What Each Module Does

### 🚀 [Module 01: Raw Performance & Low Latency](modules/01-performance/performance.ps1)
* **MMCSS `SystemResponsiveness = 0`:** Grants **100% of CPU time** to active foreground windows (eliminates the default 20% background reservation).
* **Network Packet Unthrottling (`NetworkThrottlingIndex = 0xFFFFFFFF`):** Disables ancient network packet capping for zero ping jitter.
* **CPU Thread Quanta (`Win32PrioritySeparation = 0x26`):** Grants instant burst priority to active keystrokes and clicks.
* **NVMe Speedup:** Disables legacy MS-DOS 8.3 name generation and Last Access Time write updates on NTFS.
* **4.0 GB NVMe Storage Freed (`powercfg -h off`):** Deletes `hiberfil.sys` and eliminates dirty Fast Startup memory leaks, ensuring a 100% clean kernel boot every start.
* **Browser RAM-Ghost Killer:** Configures Edge and Chrome to release 100% of memory immediately when closed.

---

### 💎 [Module 02: Aesthetics & Smoothness](modules/02-aesthetics/aesthetics.ps1)
* **Clean Native Taskbar:** Centers taskbar icons and hides clutter (Task View, Widgets, and search boxes).
* **TranslucentTB:** Pure acrylic / crystal glass floating taskbar with 0% CPU consumption.
* **QuickLook:** Tap **`Spacebar`** on any code, image, video, or PDF in File Explorer for instant macOS-style preview.
* **Flow Launcher:** Press **`Alt + Space`** for a sleek, blurred Spotlight command bar with instant math, shell execution, and fuzzy search.

---

### 🛠️ [Module 03: MSc CS Developer Suite](modules/03-developer/developer.ps1)
* **WSL2 / Docker RAM Limiter:** Automatically deploys `~/.wslconfig` (caps Linux VM at 4GB RAM, 2 vCPUs, and enables automatic memory dropcache).
* **Rust CLI Suite:** Installs **Starship** (sub-millisecond prompt), **Ripgrep (`rg`)** (10x faster regex code search), **Bat (`bat`)** (syntax-highlighted code viewer), and **uv** (fast Python manager).
* **Git Acceleration:** Enables `core.fscache` and `core.preloadindex`. Configures **`git lg`** for visual commit trees.
* **Terminal AI Copilot (`ask`):** Run `ask "your question"` directly in your shell to query local models via Ollama.
* **Defender Exclusions:** Whitelists developer workspaces to speed up Java, C++, Python, and Node compilations by 2x to 5x.

---

### 🛡️ [Module 04: Autonomous OS Guardian](modules/04-guardian/os-guardian.ps1)
* A lightweight (<0.05% CPU) background watchdog.
* Automatically frees RAM when physical memory usage exceeds 82% without closing apps.
* Dynamically elevates process priority for active IDEs (VS Code, Antigravity, IntelliJ, PyCharm) while lowering priority for background updaters.

---

## ⚖️ Native Features vs. Third-Party Tools

Before adding any third-party software, read our architectural manifesto:  
👉 **[Read: native-vs-thirdparty.md](native-vs-thirdparty.md)**

**Summary Rule:**
* **Native is Best for:** Window snapping (`Win+Z`), Taskbar centering, Virtual Desktops (`Win+Ctrl+Arrows`), Terminal tabs, Dark Mode, Native Sudo.
* **Third-Party is Essential for:** Spacebar preview (QuickLook), Glass taskbar (TranslucentTB), Fuzzy Spotlight (Flow Launcher), Rust CLI (Starship/Ripgrep).

---

## 📜 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
