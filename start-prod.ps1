# Soundboard Production Server
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Soundboard PRODUCTION - port 5173" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

# port 5173 freigeben falls belegt
$connection = Get-NetTCPConnection -Localport 5173 -ErrorAction SilentlyContinue
if ($connection) {
    Write-Host "`nport 5173 belegt - beende alten Prozess..." -ForegroundColor Yellow
    Stop-Process -Id $connection.OwningProcess -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Build erstellen
Write-Host "`nErstelle optimierten Production Build..." -ForegroundColor Cyan
yarn build

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBuild erfolgreich!" -ForegroundColor Green
    Write-Host "Starte Production Server auf port 5173..." -ForegroundColor Cyan
    yarn preview
} else {
    Write-Host "Build fehlgeschlagen!" -ForegroundColor Red
}