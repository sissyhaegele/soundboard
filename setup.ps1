# MusicPad Soundboard - Yarn Setup Script für Windows
# Dieses Skript automatisiert die Installation mit Yarn

Write-Host "================================" -ForegroundColor Cyan
Write-Host "MusicPad Soundboard Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Überprüfe ob Yarn installiert ist
Write-Host "Überprüfe Yarn-Installation..." -ForegroundColor Yellow
try {
    $yarnVersion = yarn --version
    Write-Host "✓ Yarn $yarnVersion gefunden" -ForegroundColor Green
} catch {
    Write-Host "✗ Yarn ist nicht installiert!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Bitte installiere Yarn zuerst:" -ForegroundColor Yellow
    Write-Host "npm install -g yarn" -ForegroundColor White
    Write-Host "oder besuche: https://yarnpkg.com" -ForegroundColor White
    exit 1
}

# Überprüfe ob Node.js installiert ist
Write-Host "Überprüfe Node.js-Installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js $nodeVersion gefunden" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js ist nicht installiert!" -ForegroundColor Red
    Write-Host "Bitte installiere Node.js von: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Installiere Dependencies..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Installiere Dependencies mit Yarn
yarn install

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Installation erfolgreich!" -ForegroundColor Green
    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Nächste Schritte:" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. WICHTIG: Ersetze src/App.tsx mit dem vollständigen Code!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "2. Starte die App mit:" -ForegroundColor White
    Write-Host "   yarn dev" -ForegroundColor Green
    Write-Host ""
    Write-Host "3. Öffne im Browser:" -ForegroundColor White
    Write-Host "   http://localhost:4174" -ForegroundColor Green
    Write-Host ""
    
    # Frage ob direkt gestartet werden soll
    $response = Read-Host "Möchtest du die App jetzt starten? (j/n)"
    if ($response -eq 'j' -or $response -eq 'J') {
        Write-Host ""
        Write-Host "Starte MusicPad Soundboard auf Port 4174..." -ForegroundColor Green
        yarn dev
    }
} else {
    Write-Host ""
    Write-Host "✗ Installation fehlgeschlagen!" -ForegroundColor Red
    Write-Host "Bitte überprüfe die Fehlermeldungen oben." -ForegroundColor Yellow
}
