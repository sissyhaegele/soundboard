# Soundboard Restore Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Soundboard Backup wiederherstellen" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$dataPath = "$env:USERPROFILE\Documents\SoundboardData"

# Verfügbare Backups anzeigen
$backups = Get-ChildItem "$dataPath\backups" -Directory | Sort-Object Name -Descending
if ($backups.Count -eq 0) {
    Write-Host "❌ Keine Backups gefunden!" -ForegroundColor Red
    exit
}

Write-Host "`nVerfügbare Backups:" -ForegroundColor Yellow
for ($i = 0; $i -lt $backups.Count; $i++) {
    $info = "$($backups[$i].FullName)\backup-info.json"
    if (Test-Path $info) {
        $backupInfo = Get-Content $info | ConvertFrom-Json
        Write-Host "$($i+1). $($backups[$i].Name) - $($backupInfo.audioFiles) Dateien, $($backupInfo.totalSizeMB) MB" -ForegroundColor White
    } else {
        Write-Host "$($i+1). $($backups[$i].Name)" -ForegroundColor White
    }
}

$choice = Read-Host "`nWelches Backup wiederherstellen? (Nummer)"
$selectedBackup = $backups[$choice - 1]

if (-not $selectedBackup) {
    Write-Host "❌ Ungültige Auswahl!" -ForegroundColor Red
    exit
}

Write-Host "`n✓ Gewählt: $($selectedBackup.Name)" -ForegroundColor Green

# Audio-Dateien wiederherstellen
$audioSource = "$($selectedBackup.FullName)\audio"
$audioTarget = "$dataPath\audio"

if (Test-Path $audioSource) {
    $audioFiles = Get-ChildItem $audioSource -File
    Write-Host "`n🎵 Stelle $($audioFiles.Count) Audio-Dateien wieder her..." -ForegroundColor Yellow
    
    foreach ($file in $audioFiles) {
        Copy-Item $file.FullName $audioTarget -Force
        Write-Host "  ✓ $($file.Name)" -ForegroundColor Gray
    }
    
    Write-Host "✓ Audio-Dateien wiederhergestellt in: $audioTarget" -ForegroundColor Green
}

# Browser-Import vorbereiten
$browserExport = "$($selectedBackup.FullName)\browser-export.json"
if (Test-Path $browserExport) {
    Write-Host "`n📋 Browser-Daten gefunden" -ForegroundColor Yellow
    
    # Import-Script generieren
    $importJS = @"
// BROWSER IMPORT SCRIPT
// 1. Öffnen Sie http://localhost:5173
// 2. F12 → Console
// 3. Führen Sie dies aus:

fetch('file:///$browserExport')
  .then(r => r.json())
  .then(data => {
    // LocalStorage wiederherstellen
    Object.keys(data.localStorage).forEach(key => {
      localStorage.setItem(key, data.localStorage[key]);
    });
    
    console.log('✅ Import erfolgreich!');
    console.log('- ' + Object.keys(data.localStorage).length + ' Einstellungen');
    console.log('- ' + data.pads.length + ' Pads');
    
    alert('Import erfolgreich! Seite wird neu geladen...');
    setTimeout(() => location.reload(), 2000);
  });
"@
    
    $importJS | Set-Clipboard
    Write-Host "✓ Import-Script in Zwischenablage!" -ForegroundColor Green
    Write-Host "`nNächste Schritte:" -ForegroundColor Yellow
    Write-Host "1. Öffnen Sie http://localhost:5173" -ForegroundColor White
    Write-Host "2. F12 → Console" -ForegroundColor White
    Write-Host "3. Script einfügen und Enter drücken" -ForegroundColor White
}

Write-Host "`n✅ WIEDERHERSTELLUNG ABGESCHLOSSEN!" -ForegroundColor Green
Start-Process explorer $audioTarget