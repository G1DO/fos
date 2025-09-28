# FOSv2 — ASU OS 2025/26

[FOS][fos-v1] is an educational OS for Ain Shams University Operating Systems Course CSW355, forked and refactored from [MIT Operating Systems Lab 6.828][mit-6.828]. It was created by [Dr. Mahmoud Hossam][dr-m-h] and is currently maintained by course staff.
**FOSv2 (2025/26 Edition)** updates the layout and build flow used this year and ships modern editor/debugger integration.

[fos-v1]: https://github.com/mahossam/FOS-Ain-Shams-University-Educational-OS
[dr-m-h]: https://github.com/mahossam/
[mit-6.828]: http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-828-operating-system-engineering-fall-2012/

<!-- TOC depthFrom:2 -->

* [1. What's Different?](#1-whats-different)
* [2. Set up Environment](#2-set-up-environment)

  * [2.1. Windows - Cygwin](#21-windows---cygwin)
  * [2.2. Windows - WSL (Recommended)](#22-windows---wsl-recommended)
  * [2.3. Linux](#23-linux)
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

![screenshot](https://user-images.githubusercontent.com/41103290/75132023-0e3f9d80-56de-11ea-9daf-e578bdcdd750.png)

## 2. Set up Environment

FOS requires a Linux environment. On Windows, use **WSL (recommended)** or **Cygwin**. Linux users follow the steps [below](#23-linux).

### 2.1. Windows - Cygwin

1. **Linux-like Environment:**

   * [Download][dl-cygwin-32] and install [**Cygwin**][cygwin] ***32-bit***.
   * Copy **`setup-x86.exe`** to **`C:\cygwin`**.
   * Open a terminal in **`C:\cygwin`** and run:

     ```cmd
     ./setup-x86.exe -q -P gdb,make,perl
     ```

2. **Toolchain:**

   * [Download][dl-toolchain] the `i386-elf-toolchain` for Windows.
   * Extract **`i386-elf-toolchain-windows.rar`** into **`C:\cygwin\opt\cross\`** *(create the folder if it doesn’t exist)*.

3. **Emulator:**

   * [Download][dl-qemu] and install [**QEMU**][qemu].
   * During setup, uncheck all system emulations **except `i386`**.

4. **Update `PATH`:**
   Add the following to your environment `PATH`:

   ```path
   C:\Program Files\qemu
   C:\cygwin\bin
   C:\cygwin\opt\cross\bin
   ```

[cygwin]: https://cygwin.com/
[dl-cygwin-32]: https://cygwin.com/install.html
[dl-toolchain]: https://github.com/YoussefRaafatNasry/fos-v2/releases/tag/toolchain
[qemu]: https://www.qemu.org/
[dl-qemu]: https://qemu.weilnetz.de/w64/2020/

### 2.2. Windows - WSL (Recommended)

> Requires Windows 10 build 16215+

The [Windows Subsystem for Linux][wsl] lets you run a GNU/Linux environment (tools, utilities, and apps) directly on Windows with minimal overhead.

1. Control Panel → Programs → Turn Windows Features on or off → enable **Windows Subsystem for Linux**.
2. Install **Ubuntu** from Microsoft Store.
3. Launch **Ubuntu**.
4. Follow the **Linux** steps in the next section (install any missing tools if a command is not found).

[wsl]: https://docs.microsoft.com/en-us/windows/wsl/about

### 2.3. Linux

```bash
# Required packages
sudo apt-get update
sudo apt-get install -y build-essential qemu-system-i386 gdb libfl-dev

# Optional: cross toolchain, if you need i386-elf-* in PATH
sudo mkdir -p /opt/cross && cd /opt/cross
sudo wget https://github.com/YoussefRaafatNasry/fos-v2/releases/download/toolchain/i386-elf-toolchain-linux.tar.bz2
sudo tar xjf i386-elf-toolchain-linux.tar.bz2
sudo rm i386-elf-toolchain-linux.tar.bz2
echo 'export PATH="$PATH:/opt/cross/bin"' >> ~/.bashrc
```

## 3. Setup Workspace

1. [Download][dl-vscode] and install [**Visual Studio Code**][vscode].
2. Download or clone this repo and open it in VS Code:

   ```bash
   git clone https://github.com/G1DO/fos.git
   cd fos/
   code .
   ```
3. **Install all** recommended extensions (bottom-right prompt).
4. Build → <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> or run:

   ```bash
   make
   ```

   Then launch:

   ```bash
   make run
   ```

[vscode]: https://code.visualstudio.com/
[dl-vscode]: https://code.visualstudio.com/

## 4. Debugging

1. Add breakpoints to your code.
2. Start Debugging → <kbd>F5</kbd>.
3. Fix your bugs!

## 5. Contribute

* Submit a PR with proposed changes — contributions are welcome.
* Open an Issue if something is wrong or unclear.
