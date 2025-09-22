# Soundboard Browser Export Helper
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Soundboard Browser-Daten Export" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$exportPath = "$env:USERPROFILE\Documents\SoundboardData\exports\export_$timestamp"
New-Item -ItemType Directory -Path $exportPath -Force | Out-Null

# JavaScript für Browser-Console generieren
$jsExport = @"
// === SOUNDBOARD EXPORT SCRIPT ===
// Kopieren Sie dies in die Browser-Console (F12)
(async () => {
  const exportData = {
    timestamp: new Date().toISOString(),
    localStorage: {},
    pads: [],
    audioCount: 0
  };
  
  // LocalStorage exportieren
  for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    if (key && (key.includes('soundboard') || key.includes('musicpad'))) {
      exportData.localStorage[key] = localStorage.getItem(key);
    }
  }
  
  // Pad-Konfiguration extrahieren
  const banksKey = Object.keys(exportData.localStorage).find(k => k.includes('banks'));
  if (banksKey) {
    const banks = JSON.parse(exportData.localStorage[banksKey]);
    banks.forEach(bank => {
      bank.pads.forEach(pad => {
        if (pad.src) {
          exportData.pads.push({
            id: pad.id,
            filename: pad.filename,
            name: pad.name,
            volume: pad.volume,
            color: pad.color,
            hotkey: pad.hotkey
          });
          if (pad.source === 'idb') exportData.audioCount++;
        }
      });
    });
  }
  
  // Download als JSON
  const blob = new Blob([JSON.stringify(exportData, null, 2)], {type: 'application/json'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'soundboard-export-$timestamp.json';
  a.click();
  
  console.log('✅ Export abgeschlossen!');
  console.log(`- ${Object.keys(exportData.localStorage).length} LocalStorage Einträge`);
  console.log(`- ${exportData.pads.length} Pads konfiguriert`);
  console.log(`- ${exportData.audioCount} Audio-Dateien in IndexedDB`);
  
  alert('Export heruntergeladen!\n\nSpeichern Sie die Datei in:\n$exportPath');
})();
"@

# In Zwischenablage kopieren
$jsExport | Set-Clipboard

Write-Host "`n📋 Export-Script in Zwischenablage kopiert!" -ForegroundColor Green
Write-Host ""
Write-Host "ANLEITUNG:" -ForegroundColor Yellow
Write-Host "1. Öffnen Sie http://localhost:5173" -ForegroundColor White
Write-Host "2. Drücken Sie F12 für DevTools" -ForegroundColor White
Write-Host "3. Wechseln Sie zum 'Console' Tab" -ForegroundColor White
Write-Host "4. Fügen Sie das Script ein (Ctrl+V) und drücken Sie Enter" -ForegroundColor White
Write-Host "5. Speichern Sie die heruntergeladene JSON in:" -ForegroundColor White
Write-Host "   $exportPath" -ForegroundColor Green

# Ordner öffnen
Start-Process explorer $exportPath