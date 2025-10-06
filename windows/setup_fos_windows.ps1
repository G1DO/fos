# save as: setup_fos_windows.ps1
# run:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\setup_fos_windows.ps1

$ErrorActionPreference = 'Stop'

# ---------- helpers ----------
function Need-WinGet {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install 'App Installer' from Microsoft Store, then re-run." -ForegroundColor Yellow
    exit 1
  }
}
function Install-WinGet($id) {
  if (-not (winget list --id $id -e | Select-String $id -Quiet)) {
    Write-Host "Installing $id via winget..."
    winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
  } else { Write-Host "$id already installed." }
}
function Ensure-Scoop {
  if (-not (Test-Path "$env:USERPROFILE\scoop")) {
    Write-Host "Installing Scoop (user mode)..."
    Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
    Invoke-Expression (Invoke-WebRequest -UseBasicParsing -Uri https://get.scoop.sh).Content
  } else { Write-Host "Scoop already installed." }
  try { scoop bucket add main 2>$null | Out-Null } catch {}
}
function Scoop-Ensure ($pkg) {
  if (-not (scoop list | Select-String -SimpleMatch " $pkg ")) {
    Write-Host "Installing $pkg (Scoop, user)..."
    scoop install $pkg | Out-Null
  } else { Write-Host "$pkg already installed (Scoop)." }
}
function Add-UserPath ($dir) {
  if (-not (Test-Path $dir)) { return }
  $cur = [Environment]::GetEnvironmentVariable('Path','User'); if (-not $cur) { $cur = '' }
  $parts = $cur -split ';' | Where-Object { $_ -ne '' }
  if ($parts -notcontains $dir) {
    [Environment]::SetEnvironmentVariable('Path', ($cur + ';' + $dir).Trim(';'), 'User')
    Write-Host "Added to user PATH: $dir"
  }
}
function Extract-With7z($archive,$dest){
  $seven = "${env:ProgramFiles}\7-Zip\7z.exe"
  if (-not (Test-Path $seven)) { $seven = "$env:USERPROFILE\scoop\apps\7zip\current\7z.exe" }
  if (-not (Test-Path $seven)) { throw "7-Zip not found." }
  & $seven x $archive "-o$dest" -y | Out-Null
}
function Append-LineIfMissing($file,$line){
  if (-not (Test-Path $file)) { New-Item -ItemType File -Path $file -Force | Out-Null }
  $txt = Get-Content -LiteralPath $file -ErrorAction SilentlyContinue
  if ($txt -notcontains $line) { Add-Content -LiteralPath $file -Value $line }
}

# ---------- 0) prerequisites ----------
Need-WinGet
Install-WinGet 'Git.Git'     # Git for Windows (Git Bash)
Install-WinGet '7zip.7zip'   # 7-Zip

Ensure-Scoop
Scoop-Ensure make
Scoop-Ensure gdb

# ---------- 1) QEMU (official Windows installer, silent) ----------
$QemuVer = '20250826'
$QemuExe = Join-Path $env:TEMP "qemu-w64-setup-$QemuVer.exe"
if (-not (Test-Path $QemuExe)) {
  Write-Host "Downloading QEMU installer..."
  Invoke-WebRequest -Uri "https://qemu.weilnetz.de/w64/qemu-w64-setup-$QemuVer.exe" -OutFile $QemuExe
}
Write-Host "Installing QEMU silently..."
Start-Process $QemuExe -ArgumentList '/S' -Wait
$QemuDir = "C:\Program Files\qemu"
Add-UserPath $QemuDir

# ---------- 2) Toolchain (Windows) ----------
$ToolsRoot = "C:\FOSv2-Tools"
New-Item -ItemType Directory -Force -Path $ToolsRoot | Out-Null
$Rar = Join-Path $ToolsRoot "i386-elf-toolchain-windows.rar"

# try both known URLs
$urls = @(
  "https://github.com/YoussefRaafatNasry/fos-v2/releases/download/toolchain/i386-elf-toolchain-windows.rar",
  "https://github.com/yousinix/fos-v2/releases/download/toolchain/i386-elf-toolchain-windows.rar"
)
if (-not (Test-Path $Rar)) {
  foreach($u in $urls){
    try { Write-Host "Downloading toolchain from: $u"; Invoke-WebRequest -Uri $u -OutFile $Rar -UseBasicParsing; break }
    catch { Write-Host "  failed: $($_.Exception.Message)" }
  }
}
if (-not (Test-Path $Rar)) { throw "Could not download toolchain archive." }

Write-Host "Extracting toolchain..."
Extract-With7z $Rar $ToolsRoot

# detect actual bin directory (some archives use opt\cross\bin, others bin)
$CandidateBins = @(
  (Join-Path $ToolsRoot "opt\cross\bin"),
  (Join-Path $ToolsRoot "bin")
) + (Get-ChildItem -Path $ToolsRoot -Recurse -Filter "i386-elf-gcc.exe" -ErrorAction SilentlyContinue | ForEach-Object { Split-Path $_.FullName -Parent } | Select-Object -Unique)

$ToolchainBin = $null
foreach($b in $CandidateBins){ if (Test-Path (Join-Path $b "i386-elf-gcc.exe")) { $ToolchainBin = $b; break } }
if (-not $ToolchainBin) { throw "i386-elf-gcc.exe not found after extraction." }

# ---------- 3) PATHs ----------
# a) Git Bash PATH (permanent)
$Bashrc = Join-Path $env:USERPROFILE ".bashrc"
Append-LineIfMissing $Bashrc 'export PATH="$PATH:/c/Program Files/qemu"'

# Convert Windows path (e.g., C:\FOSv2-Tools\bin) -> /c/FOSv2-Tools/bin for bash
$ToolchainBashPath = ($ToolchainBin -replace '^([A-Za-z]):\\','/$1/').Replace('\','/')
# Build the line so $PATH is literal for bash (avoid PS parsing)
$LineForBashrc = 'export PATH="$PATH:' + $ToolchainBashPath + '"'
Append-LineIfMissing $Bashrc $LineForBashrc

# b) Windows user PATH (optional convenience)
Add-UserPath $QemuDir
Add-UserPath $ToolchainBin

# ---------- 4) Versions (via Git Bash) ----------
$GitBash = "$env:ProgramFiles\Git\bin\bash.exe"
if (-not (Test-Path $GitBash)) { $GitBash = "$env:ProgramFiles\Git\usr\bin\bash.exe" }

Write-Host "`n✅ Dependencies installed. Quick versions:"
if (Test-Path $GitBash) {
  & $GitBash -lc 'source ~/.bashrc; which make && make --version | head -n1'
  & $GitBash -lc 'source ~/.bashrc; which gdb && gdb --version | head -n1'
  & $GitBash -lc 'source ~/.bashrc; which qemu-system-i386 && qemu-system-i386 --version | head -n1'
  & $GitBash -lc 'source ~/.bashrc; which i386-elf-gcc && i386-elf-gcc --version | head -n1'
} else {
  Write-Host "Git Bash not found where expected; reinstall Git for Windows if needed." -ForegroundColor Yellow
}

Write-Host "`nNext steps (user decides repo/folder): open **Git Bash**, then in your project:"
Write-Host "  make clean && make && make run"
