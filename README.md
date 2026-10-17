# WinWorkstation: Windows 11 Architecture & Optimization Suite

[![Windows 11](https://img.shields.io/badge/Platform-Windows%2011-0078D4?logo=windows11&logoColor=white)](https://microsoft.com/windows)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Zero Telemetry](https://img.shields.io/badge/Telemetry-Minimized-brightgreen.svg)]()
[![Hardware Architecture](https://img.shields.io/badge/Kernel-Low%20Latency-orange.svg)]()

**WinWorkstation** is an open-source, modular systems engineering toolkit designed to optimize Microsoft Windows 11 for software engineers, computer science researchers, and high-throughput workstations. 

It provides fine-grained kernel latency tuning, non-destructive background service minimization, storage engine I/O acceleration, modern workstation ergonomics, and developer environment provisioning.

---

## Architecture Overview

The repository is modularly decoupled into focused functional subsystems:

```
WinWorkstation/
├── modules/
│   ├── 01-performance/        # Kernel scheduling, MMCSS, network pacing & NVMe I/O
│   ├── 02-aesthetics/         # Workstation ergonomics, DWM acrylic blur & spotlight palette
│   ├── 03-developer/          # POSIX shell layer, Rust CLI suite & WSL2 resource governance
│   └── 04-guardian/           # Dynamic working-set memory reclamation & process priority balancer
├── native-vs-thirdparty.md    # Architectural assessment: Native Windows subsystems vs 3rd-party
├── main.ps1                   # Master CLI orchestrator with parameter dispatch and interactive TUI
├── install.bat                # Automated administrative elevation bootstrap
├── .gitignore
├── LICENSE                    # MIT License
└── README.md
```

---

## Quickstart

### Automated Interactive Bootstrap (Administrator)
1. Clone or download the repository.
2. Execute **`install.bat`** (prompts for UAC elevation if required).
3. Select the desired module from the interactive prompt:
   * **[1] Full Workstation Suite** (Performance + Ergonomics + Developer Toolchain)
   * **[2] Kernel & Latency Optimization Only** (Module 01)
   * **[3] Modern Ergonomics & Aesthetics Only** (Module 02)
   * **[4] Developer & Systems Toolchain Only** (Module 03)
   * **[5] Autonomous Resource Guardian Watchdog** (Module 04)

### Automated Headless Execution (PowerShell)
```powershell
# Execute full workstation deployment
.\main.ps1 -All

# Apply kernel and I/O optimizations only
.\main.ps1 -Performance

# Provision modern ergonomics only
.\main.ps1 -Aesthetics

# Provision developer toolchains only
.\main.ps1 -Developer
```

---

## Detailed Module Specifications

### [Module 01: Kernel & Hardware Optimization](modules/01-performance/performance.ps1)
* **MMCSS Foreground Quantum Allocation (`SystemResponsiveness = 0`):** Reallocates 100% of CPU cycles to the active interactive foreground process, eliminating default background reservations.
* **Network Throttling Removal (`NetworkThrottlingIndex = 0xFFFFFFFF`):** Disables historical 10 packets/ms throttling on non-multimedia traffic, eliminating packet queuing and ping jitter.
* **Thread Quantum Dispatch (`Win32PrioritySeparation = 0x26`):** Configures short, variable, high-priority quanta to foreground threads for immediate burst responsiveness.
* **NVMe Storage Subsystem Acceleration:**
  * Disables NTFS 8.3 legacy DOS directory lookup generation (`fsutil 8dot3name set 1`).
  * Disables Last Access timestamp writing on file read operations (`fsutil behavior set disablelastaccess 1`).
* **Clean Kernel Initialization:** Purges `hiberfil.sys` (`powercfg -h off`), reclaiming ~4 GB of NVMe storage and preventing dirty Fast Startup session carryover.
* **Background Process Working-Set Governance:** Applies enterprise policies to prevent closed browser processes from persisting in background idle memory.

---

### [Module 02: Workstation Ergonomics & Desktop Aesthetics](modules/02-aesthetics/aesthetics.ps1)
* **Streamlined Taskbar Configuration:** Centers application icons, suppresses default promotional clutter (Widgets, Task View, promotional search bars).
* **Direct DWM Composition (`TranslucentTB`):** Leverages native Windows Desktop Window Manager (DWM) composition APIs to create an unobtrusive acrylic glass taskbar with 0% CPU overhead.
* **Instantaneous File Inspection (`QuickLook`):** Enables native spacebar inspection of markdown, source code, PDFs, media, and archives without launching full application suites.
* **Unified Command Palette (`Flow Launcher`):** High-speed, keyboard-driven navigation (`Alt + Space`) for fuzzy application launching, arithmetic calculations, and system commands.

---

### [Module 03: Software Engineering & Systems Toolchain](modules/03-developer/developer.ps1)
* **WSL2 Resource Governance:** Deploys `~/.wslconfig` to allocate a deterministic 4 GB memory ceiling and 2 vCPUs to virtual machine workloads, enabling automatic memory reclamation (`autoMemoryReclaim = dropcache`).
* **High-Throughput CLI Utilities:** Installs compiled Rust/C++ developer tooling via `winget`:
  * **Starship:** High-efficiency, cross-shell prompt with asynchronous Git status.
  * **Ripgrep (`rg`):** Multi-threaded line-oriented regex search engine.
  * **Bat (`bat`):** Syntax-highlighted text reader with Git modification gutter integration.
  * **uv:** High-speed Python package and virtual environment resolver.
* **Git Engine I/O Caching:** Configures `core.fscache`, `core.preloadindex`, and a structured visual commit tree (`git lg`).
* **Windows Defender Workspace Exclusions:** Whitelists local build paths and language dependency caches (`.cargo`, `.rustup`, `.m2`, `.gradle`) to eliminate build pipeline I/O locks.

---

### [Module 04: Dynamic Resource Management Guardian](modules/04-guardian/os-guardian.ps1)
* Autonomous, low-overhead (<0.05% CPU) background watchdog.
* Proactively monitors physical memory pressure; triggers clean working-set trims if system utilization exceeds 82%.
* Dynamically elevates priority classes for active IDEs (VS Code, Antigravity, CLion, IntelliJ) while lowering priorities for background updater services.

---

## Architectural Principles: Native vs. Third-Party

Before introducing third-party components, consult our architectural analysis:  
👉 **[Read: native-vs-thirdparty.md](native-vs-thirdparty.md)**

WinWorkstation strictly enforces that native Windows 11 capabilities (Snap Layouts, Virtual Desktops, Terminal Tabs, Windows Sudo) are leveraged whenever possible, reserving third-party tools solely for capabilities absent from the NT platform.

---

## License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for complete terms.
