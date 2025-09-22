# Service Worker & Cache Cleanup für Soundboard
param(
    [string]$Port = "4174"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Service Worker Cleanup - Port $Port" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Chrome Pfade
$chromePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 2"
)

# Edge Pfade
$edgePaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Profile 1"
)

Write-Host "`n1. Beende Browser-Prozesse..." -ForegroundColor Yellow

# Chrome beenden
$chrome = Get-Process chrome -ErrorAction SilentlyContinue
if ($chrome) {
    Write-Host "   Chrome gefunden - wird beendet" -ForegroundColor Red
    $chrome | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# Edge beenden
$edge = Get-Process msedge -ErrorAction SilentlyContinue
if ($edge) {
    Write-Host "   Edge gefunden - wird beendet" -ForegroundColor Red
    $edge | Stop-Process -Force
    Start-Sleep -Seconds 2
}

Write-Host "`n2. Lösche Service Worker Daten..." -ForegroundColor Yellow

# Service Worker Ordner löschen
foreach ($path in ($chromePaths + $edgePaths)) {
    $swPath = "$path\Service Worker"
    if (Test-Path $swPath) {
        try {
            Remove-Item -Path $swPath -Recurse -Force -ErrorAction Stop
            Write-Host "   Gelöscht: $swPath" -ForegroundColor Green
        } catch {
            Write-Host "   Konnte nicht löschen: $swPath" -ForegroundColor Red
        }
    }
}

Write-Host "`n3. Lösche Cache Storage..." -ForegroundColor Yellow

# Cache Storage löschen
foreach ($path in ($chromePaths + $edgePaths)) {
    $cachePath = "$path\Cache"
    $cacheStoragePath = "$path\CacheStorage"
    
    foreach ($cache in @($cachePath, $cacheStoragePath)) {
        if (Test-Path $cache) {
            try {
                Remove-Item -Path $cache -Recurse -Force -ErrorAction Stop
                Write-Host "   Gelöscht: $cache" -ForegroundColor Green
            } catch {
                Write-Host "   Konnte nicht löschen: $cache" -ForegroundColor Red
            }
        }
    }
}

Write-Host "`n4. Starte Browser mit deaktiviertem Cache..." -ForegroundColor Yellow

# Chrome ohne Cache starten
$chromeExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (Test-Path $chromeExe) {
    Start-Process $chromeExe -ArgumentList "--disable-application-cache", "--disable-offline-load-stale-cache", "--disk-cache-size=1", "http://localhost:$Port"
    Write-Host "   Chrome gestartet (Cache deaktiviert)" -ForegroundColor Green
} else {
    # Edge als Alternative
    Start-Process msedge -ArgumentList "--disable-application-cache", "--disable-offline-load-stale-cache", "--disk-cache-size=1", "http://localhost:$Port"
    Write-Host "   Edge gestartet (Cache deaktiviert)" -ForegroundColor Green
}

Write-Host "`n✅ Service Worker Cleanup abgeschlossen!" -ForegroundColor Green
Write-Host "   Browser wurde ohne Cache neu gestartet" -ForegroundColor Cyan
Write-Host "   Starten Sie jetzt: yarn dev" -ForegroundColor Yellow