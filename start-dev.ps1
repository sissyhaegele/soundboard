# MusicPad Soundboard - Force Development Start
# This script corresponds to the "dev:force" command in package.json

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MUSICPAD SOUNDBOARD - FORCE START" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "C:\Projekte\soundboard"

# Change to project directory
Set-Location -Path $projectPath -ErrorAction Stop

# Kill any process using port 5173
Write-Host "[INFO] Checking for processes on port 5173..." -ForegroundColor Yellow
$processOnPort = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique

if ($processOnPort) {
    Write-Host "[INFO] Found process using port 5173, terminating..." -ForegroundColor Yellow
    foreach ($pid in $processOnPort) {
        $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "  - Stopping: $($process.Name) (PID: $pid)" -ForegroundColor Gray
            Stop-Process -Id $pid -Force
        }
    }
    Start-Sleep -Seconds 2
    Write-Host "[OK] Port 5173 is now free!" -ForegroundColor Green
} else {
    Write-Host "[OK] Port 5173 is available" -ForegroundColor Green
}

Write-Host ""

# Check for node_modules
if (!(Test-Path "node_modules")) {
    Write-Host "[INFO] Installing dependencies..." -ForegroundColor Yellow
    yarn install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to install dependencies!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# Clear Vite cache if it exists
if (Test-Path "node_modules\.vite") {
    Write-Host "[INFO] Clearing Vite cache..." -ForegroundColor Yellow
    Remove-Item -Path "node_modules\.vite" -Recurse -Force
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting MusicPad Soundboard..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PWA will be available at:" -ForegroundColor White
Write-Host "  http://localhost:5173" -ForegroundColor Cyan
Write-Host ""

# Start Vite dev server
yarn dev