# Download and install Git for Windows if not already installed
if (-not (Test-Path "C:\Program Files\Git\bin\git.exe")) {
    Write-Host "Git for Windows not found. Downloading installer..."
    Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.31.1.windows.1/Git-2.31.1-64-bit.exe" -OutFile "git-installer.exe"
    Write-Host "Installing Git for Windows..."
    Start-Process -FilePath ".\git-installer.exe" -ArgumentList "/VERYSILENT" -Wait
    Remove-Item ".\git-installer.exe"
}

# Create a temporary directory for downloads
New-Item -ItemType Directory -Path ".\rsync_temp" -Force | Out-Null
Set-Location ".\rsync_temp"

# Download the latest rsync binary package and its dependencies
Write-Host "Downloading rsync package and dependencies..."
Invoke-WebRequest -Uri "https://repo.msys2.org/msys/x86_64/rsync-3.3.0-1-x86_64.pkg.tar.zst" -OutFile "rsync.pkg.tar.xz"
Invoke-WebRequest -Uri "https://repo.msys2.org/msys/x86_64/libxxhash-0.8.2-1-x86_64.pkg.tar.zst" -OutFile "libxxhash.pkg.tar.zst"
Invoke-WebRequest -Uri "https://repo.msys2.org/msys/x86_64/libzstd-1.5.6-1-x86_64.pkg.tar.zst" -OutFile "libzstd.pkg.tar.zst"

# Extract the contents of the packages to the Git directory
Write-Host "Extracting packages..."
tar -xf "rsync.pkg.tar.xz" -C "C:\Program Files\Git"
tar -xf "libxxhash.pkg.tar.zst" -C "C:\Program Files\Git" 
tar -xf "libzstd.pkg.tar.zst" -C "C:\Program Files\Git"

# Clean up the temporary directory
Set-Location ".."
Remove-Item -Recurse -Force ".\rsync_temp"

# Create a batch file for running rsync from cmd.exe and PowerShell
Write-Host "Creating rsync.bat file..."
$rsyncBatContent = '@echo off' + [Environment]::NewLine + '"C:\Program Files\Git\usr\bin\rsync.exe" %*'
New-Item -ItemType File -Path "C:\Windows\rsync.bat" -Value $rsyncBatContent -Force | Out-Null

Write-Host "rsync installation completed successfully!"