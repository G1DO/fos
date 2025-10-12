# FOS — ASU Operating Systems 2025/26

[FOS][fos-v1] is an educational OS for Ain Shams University Operating Systems Course **CSW355**, forked and refactored from [MIT Operating Systems Lab 6.828][mit-6.828].
It was created by [Dr. Mahmoud Hossam][dr-m-h] and is currently maintained by the course staff.
**FOSv2 (2025/26 Edition)** updates the layout and build flow for this year, featuring modern editor/debugger integration.

[fos-v1]: https://github.com/mahossam/FOS-Ain-Shams-University-Educational-OS
[dr-m-h]: https://github.com/mahossam/
[mit-6.828]: http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/

---

## Table of Contents

* [1. What's Different?](#1-whats-different)
* [2. Set up Environment](#2-set-up-environment)

  * [2.1. Windows - Automatic Setup (Recommended)](#21-windows---automatic-setup-recommended)
  * [2.2. Windows - Cygwin (Deprecated)](#22-windows---cygwin-deprecated)
  * [2.3. Windows - WSL (Recommended)](#23-windows---wsl-alternative)
  * [2.4. Linux](#24-linux)
* [3. Setup Workspace](#3-setup-workspace)
* [4. Debugging](#4-debugging)
* [5. Contribute](#5-contribute)

---

## 1. What's Different?

1. **No Eclipse!** — Works with any text editor; *defaults to Visual Studio Code*
2. **QEMU instead of Bochs** — Faster, fewer configs, and more options
3. **Independent source tree** — OS code separated from build dependencies
4. **Cleanups** — JOS leftovers removed
5. **Smaller footprint** — Unused packages/files dropped
6. **Open source** — Contributions and fixes welcome
7. **New targets** — `make run` (QEMU) and `make debug` (QEMU+GDB on port `26000`) for the 25/26 edition

---

## 2. Set up Environment

FOS requires a Linux-like environment to build and run correctly.
On Windows, use the **Automatic Setup Script (Recommended)** or **WSL**.
⚠️ **Cygwin is deprecated** — it no longer works reliably with the modern FOSv2 toolchain and QEMU.

---

### 2.1. Windows - Automatic Setup (Recommended)

> **Note:** Make sure PowerShell is updated to the latest version. After updating, it may be called **PowerShell 7** instead of Windows PowerShell.

#### Step 1: One-Line Install Command

Simply open **PowerShell** (normal mode, not Administrator) and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://github.com/G1DO/fos/releases/latest/download/setup_fos_windows.ps1 | iex
```

💡 These scripts automate the installation and configuration of all dependencies required to build and run **FOS** on Windows.
For more details or to view the full script, visit [**G1DO/fos-windows-setup**](https://github.com/G1DO/fos-windows-setup).

---

#### Step 2: Build the Project (Git Bash)

After installation completes:

Open **Git Bash** (or VS Code terminal using Git Bash) and run:

```bash
# 1) Load environment variables
source ~/.bashrc

# 2) Sanity checks (should print valid paths/versions)
which i386-elf-gcc
which qemu-system-i386

# 3) Clone and build FOS
git clone https://github.com/G1DO/fos.git
cd fos
make
make run
```

✅ **QEMU** will launch and boot FOS automatically — no additional setup required.

---

### 2.2. Windows - Cygwin (Deprecated)

> ⚠️ **Cygwin is outdated and no longer supported.**
>
> It frequently breaks with the latest toolchain and QEMU versions.
> Please use the **Automatic Setup Script** or **WSL** instead.

---

### 2.3. Windows - WSL (Recommended)

> Requires Windows 10 build 16215+

The [Windows Subsystem for Linux][wsl] lets you run a genuine GNU/Linux environment (tools, utilities, and apps) directly on Windows.

1. Control Panel → Programs → Turn Windows Features on or off → enable **Windows Subsystem for Linux**
2. Install **Ubuntu** from Microsoft Store
3. Launch **Ubuntu**
4. Follow the **Linux** instructions below

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

1. [Download][dl-vscode] and install [**Visual Studio Code**][vscode]

2. Clone this repository and open it in VS Code:

   ```bash
   git clone https://github.com/G1DO/fos.git
   cd fos/
   code .
   ```

3. Install all recommended extensions when prompted

4. Build the project using:

   ```bash
   make
   make run
   ```

[vscode]: https://code.visualstudio.com/
[dl-vscode]: https://code.visualstudio.com/

---

## 4. Debugging

1. Add breakpoints to your code
2. Start Debugging → <kbd>F5</kbd>
3. Fix your bugs and rerun

---

## 5. Contribute

* Submit a PR with improvements or bug fixes — contributions are always welcome
* Open an Issue if something doesn’t work or needs clarification
