# Quick Check vor Commit
Write-Host "Running Quick Check..." -ForegroundColor Cyan

# Check if server is running
$portInUse = Get-NetTCPConnection -LocalPort 4174 -ErrorAction SilentlyContinue

if ($portInUse) {
    Write-Host "✓ Server läuft auf Port 4174" -ForegroundColor Green
} else {
    Write-Host "⚠ Server läuft nicht auf Port 4174" -ForegroundColor Yellow
}

# Check for uncommitted changes
$status = git status --porcelain

if ($status) {
    Write-Host "Uncommitted changes:" -ForegroundColor Yellow
    git status --short
} else {
    Write-Host "✓ Keine uncommitted changes" -ForegroundColor Green
}

# Show current branch
$branch = git branch --show-current
Write-Host "Current branch: $branch" -ForegroundColor Cyan

if ($branch -eq "main") {
    Write-Host "⚠ WARNING: You are on main branch!" -ForegroundColor Red
}