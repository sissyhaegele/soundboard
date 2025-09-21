@echo off
title MusicPad Soundboard - Yarn Setup

echo ================================
echo MusicPad Soundboard Setup
echo ================================
echo.

:: Überprüfe Yarn
echo Ueberpruefe Yarn-Installation...
yarn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Yarn ist nicht installiert!
    echo.
    echo Bitte installiere Yarn zuerst:
    echo npm install -g yarn
    echo oder besuche: https://yarnpkg.com
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Yarn gefunden
)

:: Überprüfe Node.js
echo Ueberpruefe Node.js-Installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Node.js ist nicht installiert!
    echo Bitte installiere Node.js von: https://nodejs.org
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Node.js gefunden
)

echo.
echo ================================
echo Installiere Dependencies...
echo ================================
echo.

:: Installiere Dependencies
call yarn install

if %errorlevel% equ 0 (
    echo.
    echo [OK] Installation erfolgreich!
    echo.
    echo ================================
    echo Naechste Schritte:
    echo ================================
    echo.
    echo 1. WICHTIG: Ersetze src/App.tsx mit dem vollstaendigen Code!
    echo.
    echo 2. Starte die App mit:
    echo    yarn dev
    echo.
    echo 3. Oeffne im Browser:
    echo    http://localhost:4174
    echo.
    
    :: Frage ob App gestartet werden soll
    set /p start="Moechtest du die App jetzt starten? (j/n): "
    if /i "%start%"=="j" (
        echo.
        echo Starte MusicPad Soundboard auf Port 4174...
        call yarn dev
    )
) else (
    echo.
    echo [X] Installation fehlgeschlagen!
    echo Bitte ueberpruefe die Fehlermeldungen.
    echo.
    pause
)
