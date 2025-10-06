# FOS — ASU Operating Systems 2025/26

[FOS][fos-v1] is an educational OS for Ain Shams University Operating Systems Course CSW355, forked and refactored from [MIT Operating Systems Lab 6.828][mit-6.828]. It was created by [Dr. Mahmoud Hossam][dr-m-h] and is currently maintained by course staff.
**FOSv2 (2025/26 Edition)** updates the layout and build flow used this year and ships modern editor/debugger integration.

[fos-v1]: https://github.com/mahossam/FOS-Ain-Shams-University-Educational-OS
[dr-m-h]: https://github.com/mahossam/
[mit-6.828]: http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/

<!-- TOC depthFrom:2 -->

* [1. What's Different?](#1-whats-different)
* [2. Set up Environment](#2-set-up-environment)

  * [2.1. Windows - Automatic Setup (Recommended)](#21-windows---automatic-setup-recommended)
  * [2.2. Windows - Cygwin (Deprecated)](#22-windows---cygwin-deprecated)
  * [2.3. Windows - WSL (Alternative)](#23-windows---wsl-alternative)
  * [2.4. Linux](#24-linux)
* [3. Setup Workspace](#3-setup-workspace)
* [4. Debugging](#4-debugging)
* [5. Contribute](#5-contribute)

<!-- /TOC -->

## 1. What's Different?

1. **No Eclipse!** — Works with any editor; *defaults to Visual Studio Code*.
2. **QEMU instead of Bochs** — Faster, fewer configs, richer options.
3. **Independent source tree** — OS code separated from env/tooling.
4. **Cleanups** — JOS leftovers removed.
5. **Smaller footprint** — Unused packages/files dropped.
6. **Open source** — Contributions and fixes welcome.
7. **New targets** — `make run` (QEMU) and `make debug` (QEMU+GDB on port `26000`) for this 25/26 edition.

---

## 2. Set up Environment

FOS requires a Linux-like environment. On Windows, you can now use the **automatic setup script** (recommended), or WSL.
**Cygwin is deprecated** — it no longer works reliably with the latest FOSv2 toolchain and QEMU versions.

---

### 2.1. Windows - Automatic Setup (Recommended)

**✅ Simplest method — no WSL, no MSYS2, no manual installs.**

#### Step 1: Download the setup script

➡️ **[Download setup_fos_windows.ps1](https://raw.githubusercontent.com/G1DO/fos/main/scripts/windows/setup_fos_windows.ps1)**

This PowerShell script automatically installs and configures:

* Git for Windows (Git Bash)
* 7-Zip
* Scoop (user mode) + `make` and `gdb`
* QEMU (x64)
* i386-elf toolchain
* Updates PATH for both Windows & Git Bash
* Verifies installation with quick version checks

#### Step 2: Run the script

Open **PowerShell (normal, not Administrator)** and run:

```powershell
cd C:\path\to\where\you\downloaded\the\script
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup_fos_windows.ps1
```

> Example:
>
> ```powershell
> cd C:\Users\<YourName>\Downloads
> Set-ExecutionPolicy Bypass -Scope Process -Force
> .\setup_fos_windows.ps1
> ```

---

#### Step 3: Build the project (Git Bash)

After the script finishes:

Open **Git Bash** (or VS Code terminal set to Git Bash) and run:

```bash
# 1) Load PATH from the installer
source ~/.bashrc

# 2) Sanity checks (these should print paths/versions)
which i386-elf-gcc
which qemu-system-i386

# 3) Clone and build the repo
git clone https://github.com/G1DO/fos.git
cd fos
make
make run
```

✅ QEMU will start and boot FOS automatically.
No extra configuration is needed.

---

### 2.2. Windows - Cygwin (Deprecated)

> ⚠️ **Cygwin is outdated and not recommended.**
> It often fails with the current toolchain and QEMU on modern Windows.
> Please use the **Automatic Setup** above or **WSL** below instead.

---

### 2.3. Windows - WSL (Alternative)

> Requires Windows 10 build 16215+

The [Windows Subsystem for Linux][wsl] lets you run a GNU/Linux environment (tools, utilities, and apps) directly on Windows with minimal overhead.

1. Control Panel → Programs → Turn Windows Features on or off → enable **Windows Subsystem for Linux**
2. Install **Ubuntu** from Microsoft Store
3. Launch **Ubuntu**
4. Follow the **Linux** steps below (install any missing tools if a command is not found)

[wsl]: https://docs.microsoft.com/en-us/windows/wsl/about

---

### 2.4. Linux

```bash
# Required packages
sudo apt-get update
sudo apt-get install -y build-essential qemu-system-i386 gdb libfl-dev

# Optional: cross toolchain
sudo mkdir -p /opt/cross && cd /opt/cross
sudo wget https://github.com/YoussefRaafatNasry/fos-v2/releases/download/toolchain/i386-elf-toolchain-linux.tar.bz2
sudo tar xjf i386-elf-toolchain-linux.tar.bz2 && rm i386-elf-toolchain-linux.tar.bz2
echo 'export PATH="$PATH:/opt/cross/bin"' >> ~/.bashrc
source ~/.bashrc
```

---

## 3. Setup Workspace

1. [Download][dl-vscode] and install [**Visual Studio Code**][vscode].

2. Clone this repo and open it in VS Code:

   ```bash
   git clone https://github.com/G1DO/fos.git
   cd fos/
   code .
   ```

3. Install all recommended extensions (bottom-right prompt).

4. Build with:

   ```bash
   make
   make run
   ```

[vscode]: https://code.visualstudio.com/
[dl-vscode]: https://code.visualstudio.com/

---

## 4. Debugging

1. Add breakpoints to your code.
2. Start Debugging → <kbd>F5</kbd>.
3. Fix your bugs!

---

## 5. Contribute

* Submit a PR with proposed changes — contributions are welcome.
* Open an Issue if something is unclear or broken.

