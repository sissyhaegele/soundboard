# Autostart bei Windows-Start einrichten
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Projekte\soundboard\backup-service.ps1"

$trigger = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask -TaskName "SoundboardBackupService" `
    -Action $action `
    -Trigger $trigger `
    -Description "Soundboard Backup Service" `
    -RunLevel Highest

Write-Host "✓ Backup-Service wird bei Windows-Start gestartet" -ForegroundColor Green