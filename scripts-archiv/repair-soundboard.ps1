# Soundboard Project Repair Script
# Diagnostiziert und repariert fehlende Dateien

$ProjectPath = "C:\Projekte\soundboard"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Soundboard Projekt-Diagnose" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Prüfe Verzeichnis
if (Test-Path $ProjectPath) {
    Write-Host "[OK] Ordner existiert: $ProjectPath" -ForegroundColor Green
    Set-Location $ProjectPath
} else {
    Write-Host "[X] Ordner nicht gefunden: $ProjectPath" -ForegroundColor Red
    Write-Host "Erstelle Ordner..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $ProjectPath -Force
    Set-Location $ProjectPath
}

Write-Host ""
Write-Host "Prüfe vorhandene Dateien:" -ForegroundColor Yellow
Write-Host "--------------------------"

# Liste alle Dateien auf
$files = Get-ChildItem -Path . -Recurse -File | Where-Object { $_.DirectoryName -notlike "*node_modules*" }
if ($files.Count -gt 0) {
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        Write-Host "  $relativePath" -ForegroundColor Gray
    }
} else {
    Write-Host "  Keine Dateien gefunden!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Prüfe kritische Dateien:" -ForegroundColor Yellow
Write-Host "-------------------------"

$criticalFiles = @{
    "package.json" = $false
    "src\App.tsx" = $false
    "src\main.tsx" = $false
    "src\index.css" = $false
    "index.html" = $false
    "vite.config.ts" = $false
}

foreach ($file in $criticalFiles.Keys) {
    if (Test-Path $file) {
        Write-Host "[OK] $file" -ForegroundColor Green
        $criticalFiles[$file] = $true
    } else {
        Write-Host "[X] $file FEHLT" -ForegroundColor Red
    }
}

# Wenn package.json fehlt, erstelle sie
if (-not $criticalFiles["package.json"]) {
    Write-Host ""
    Write-Host "Erstelle fehlende package.json..." -ForegroundColor Yellow
    
    $packageContent = @'
{
  "name": "musicpad-soundboard",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --port 4174",
    "build": "vite build",
    "preview": "vite preview --port 4174",
    "serve": "vite preview --port 4174"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "lucide-react": "^0.263.1",
    "jszip": "^3.10.1",
    "file-saver": "^2.0.5",
    "react-beautiful-dnd": "^13.1.1",
    "wavesurfer.js": "^7.4.2"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "@types/react-dom": "^18.2.17",
    "@types/react-beautiful-dnd": "^13.1.6",
    "@vitejs/plugin-react": "^4.2.1",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.33",
    "tailwindcss": "^3.4.1",
    "typescript": "^5.2.2",
    "vite": "^5.0.8",
    "vite-plugin-pwa": "^0.17.4"
  }
}
'@
    
    $packageContent | Out-File -FilePath "package.json" -Encoding UTF8
    Write-Host "[OK] package.json erstellt!" -ForegroundColor Green
}

# Wenn vite.config.ts fehlt
if (-not (Test-Path "vite.config.ts")) {
    Write-Host "Erstelle vite.config.ts..." -ForegroundColor Yellow
    
    $viteContent = @'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 4174,
    host: true
  },
  preview: {
    port: 4174,
    host: true
  }
})
'@
    
    $viteContent | Out-File -FilePath "vite.config.ts" -Encoding UTF8
    Write-Host "[OK] vite.config.ts erstellt!" -ForegroundColor Green
}

# Prüfe src Ordner
if (-not (Test-Path "src")) {
    Write-Host "Erstelle src Ordner..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "src" -Force
}

# Prüfe ob App.tsx vorhanden und vollständig ist
if (Test-Path "src\App.tsx") {
    $appSize = (Get-Item "src\App.tsx").Length
    if ($appSize -gt 10000) {
        Write-Host "[OK] App.tsx ist vollständig ($appSize bytes)" -ForegroundColor Green
    } else {
        Write-Host "[!] App.tsx möglicherweise unvollständig ($appSize bytes)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Diagnose abgeschlossen" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Frage ob Dependencies installiert werden sollen
$response = Read-Host "Soll yarn install ausgeführt werden? (j/n)"

if ($response -eq 'j' -or $response -eq 'J') {
    Write-Host ""
    Write-Host "Führe yarn install aus..." -ForegroundColor Green
    yarn install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "[OK] Installation erfolgreich!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starte mit: yarn dev" -ForegroundColor Cyan
    } else {
        Write-Host "[X] Installation fehlgeschlagen" -ForegroundColor Red
    }
}
