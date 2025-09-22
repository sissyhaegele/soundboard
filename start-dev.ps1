# Soundboard Dev Server mit Port-Management
param(
    [int]$Port = 5173
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Soundboard Dev Server - Port $Port" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# PrÃ¼fe ob Port belegt ist
$connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue

if ($connection) {
    Write-Host "`nPort $Port ist belegt!" -ForegroundColor Yellow
    
    # Finde den Prozess
    $process = Get-Process -Id $connection.OwningProcess -ErrorAction SilentlyContinue
    
    if ($process) {
        Write-Host "Prozess gefunden: $($process.Name) (PID: $($process.Id))" -ForegroundColor Yellow
        
        # Nur Node/Vite Prozesse automatisch beenden
        if ($process.Name -match "node|vite") {
            Write-Host "Beende alten Node/Vite Prozess..." -ForegroundColor Red
            Stop-Process -Id $process.Id -Force
            Start-Sleep -Seconds 2
            Write-Host "Prozess beendet" -ForegroundColor Green
        } else {
            Write-Host "Prozess ist kein Node/Vite: $($process.Name)" -ForegroundColor Red
            Write-Host "Manuelles Beenden erforderlich oder anderen Port verwenden" -ForegroundColor Yellow
            
            $response = Read-Host "Trotzdem beenden? (j/n)"
            if ($response -eq 'j') {
                Stop-Process -Id $process.Id -Force
                Write-Host "Prozess beendet" -ForegroundColor Green
            } else {
                Write-Host "Abgebrochen - Port $Port bleibt belegt" -ForegroundColor Red
                exit 1
            }
        }
    }
}

Write-Host "`nPort $Port ist frei" -ForegroundColor Green
Write-Host "Starte Server..." -ForegroundColor Cyan

# Server starten
yarn dev