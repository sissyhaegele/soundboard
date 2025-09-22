# Soundboard Backup Script
param(
    [string]$BackupPath = "$env:USERPROFILE\Documents\SoundboardBackups"
)

Write-Host "Soundboard Backup Tool" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

# Backup-Ordner erstellen
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$backupDir = "$BackupPath\backup_$timestamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Browser-Daten exportieren (manuell)
Write-Host "`nBitte im Browser:" -ForegroundColor Yellow
Write-Host "1. F12 öffnen" -ForegroundColor White
Write-Host "2. Application → Local Storage" -ForegroundColor White
Write-Host "3. Rechtsklick auf Einträge → Als JSON exportieren" -ForegroundColor White
Write-Host "4. Speichern in: $backupDir" -ForegroundColor Green

# Audio-Dateien Ordner
$audioDir = "$backupDir\audio"
New-Item -ItemType Directory -Path $audioDir -Force | Out-Null

Write-Host "`nLegen Sie Ihre Audio-Dateien hier ab:" -ForegroundColor Yellow
Write-Host $audioDir -ForegroundColor Green

# Ordner öffnen
Start-Process explorer $backupDir

Write-Host "`n✓ Backup-Ordner erstellt: $backupDir" -ForegroundColor Green