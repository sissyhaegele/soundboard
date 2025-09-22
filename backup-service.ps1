# Soundboard Backup Service - Läuft als lokaler HTTP-Server
param(
    [int]$Port = 8888,
    [string]$DataPath = "$env:USERPROFILE\Documents\SoundboardData"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Soundboard Backup Service" -ForegroundColor Cyan
Write-Host "Port: $Port" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Add-Type -AssemblyName System.Web

# HTTP Listener erstellen
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")

try {
    $listener.Start()
    Write-Host "✓ Service läuft auf http://localhost:$Port" -ForegroundColor Green
    Write-Host "Warte auf Backup-Anfragen..." -ForegroundColor Yellow
    
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # CORS Headers für Browser-Zugriff
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")
        
        $url = $request.Url.LocalPath
        
        switch ($url) {
            "/backup" {
                Write-Host "`n📦 Backup angefordert..." -ForegroundColor Cyan
                
                # Backup erstellen
                $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
                $backupPath = "$DataPath\backups\backup_$timestamp"
                New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
                
                # Audio-Dateien kopieren
                if (Test-Path "$DataPath\audio") {
                    Copy-Item "$DataPath\audio\*" "$backupPath\" -Force
                    $audioCount = (Get-ChildItem "$DataPath\audio" -File).Count
                } else {
                    $audioCount = 0
                }
                
                # Config aus POST-Body lesen (falls vorhanden)
                if ($request.HasEntityBody) {
                    $reader = New-Object System.IO.StreamReader($request.InputStream)
                    $configJson = $reader.ReadToEnd()
                    $configJson | Out-File "$backupPath\config.json"
                    Write-Host "  ✓ Config gespeichert" -ForegroundColor Green
                }
                
                # Backup-Info
                @{
                    status = "success"
                    timestamp = $timestamp
                    path = $backupPath
                    audioFiles = $audioCount
                } | ConvertTo-Json | Out-File "$backupPath\info.json"
                
                # Antwort senden
                $responseJson = @{
                    success = $true
                    message = "Backup erstellt: $timestamp"
                    path = $backupPath
                    files = $audioCount
                } | ConvertTo-Json
                
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseJson)
                $response.ContentType = "application/json"
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
                
                Write-Host "  ✓ Backup erstellt: $backupPath" -ForegroundColor Green
            }
            
            "/restore" {
                Write-Host "`n🔄 Restore angefordert..." -ForegroundColor Cyan
                
                # Neuestes Backup finden
                $latestBackup = Get-ChildItem "$DataPath\backups" -Directory | 
                                Sort-Object Name -Descending | 
                                Select-Object -First 1
                
                if ($latestBackup) {
                    $configPath = "$($latestBackup.FullName)\config.json"
                    if (Test-Path $configPath) {
                        $configContent = Get-Content $configPath -Raw
                        
                        $buffer = [System.Text.Encoding]::UTF8.GetBytes($configContent)
                        $response.ContentType = "application/json"
                        $response.ContentLength64 = $buffer.Length
                        $response.OutputStream.Write($buffer, 0, $buffer.Length)
                        
                        Write-Host "  ✓ Config gesendet von: $($latestBackup.Name)" -ForegroundColor Green
                    }
                }
            }
            
            "/status" {
                $responseJson = @{
                    running = $true
                    dataPath = $DataPath
                    backupCount = (Get-ChildItem "$DataPath\backups" -Directory -ErrorAction SilentlyContinue).Count
                } | ConvertTo-Json
                
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseJson)
                $response.ContentType = "application/json"
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            default {
                $response.StatusCode = 404
            }
        }
        
        $response.Close()
    }
} finally {
    $listener.Stop()
}