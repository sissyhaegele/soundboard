@echo off
setlocal enabledelayedexpansion
title MusicPad Soundboard Server
color 0A

echo ==========================================
echo     MUSICPAD SOUNDBOARD - PWA STARTER
echo ==========================================
echo     Author: Sissy Haegele
echo ==========================================
echo.

REM Projektverzeichnis setzen
set PROJECT_PATH=C:\Projekte\soundboard
cd /d "%PROJECT_PATH%" 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Projektverzeichnis nicht gefunden: %PROJECT_PATH%
    echo         Bitte passe den Pfad in dieser Datei an!
    pause
    exit /b 1
)

echo [INFO] Arbeitsverzeichnis: %CD%
echo.

REM Node.js prüfen
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Node.js ist nicht installiert oder nicht im PATH!
    echo         Installiere Node.js von: https://nodejs.org/
    pause
    exit /b 1
)

REM Yarn prüfen
where yarn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0E
    echo [WARNUNG] Yarn ist nicht installiert!
    echo           Installiere Yarn mit: npm install -g yarn
    echo.
    echo [INFO] Versuche Yarn zu installieren...
    call npm install -g yarn
    if %ERRORLEVEL% NEQ 0 (
        color 0C
        echo [ERROR] Yarn konnte nicht installiert werden!
        echo         Verwende stattdessen npm...
        set USE_NPM=true
    ) else (
        echo [OK] Yarn wurde installiert!
        set USE_NPM=false
    )
) else (
    set USE_NPM=false
)

echo.

REM Dependencies installieren falls nötig
if not exist "node_modules\" (
    echo [INFO] node_modules Ordner fehlt - installiere Dependencies...
    if "%USE_NPM%"=="true" (
        call npm install
    ) else (
        call yarn install
    )
    if %ERRORLEVEL% NEQ 0 (
        color 0C
        echo [ERROR] Fehler beim Installieren der Dependencies!
        pause
        exit /b 1
    )
    echo [OK] Dependencies wurden installiert!
    echo.
) else (
    echo [OK] Dependencies sind bereits installiert
)

REM PWA Build Status prüfen
if not exist "dist\" (
    echo [INFO] Kein Build-Ordner gefunden.
    echo        Tipp: Fuer Production Build nutze 'yarn build'
    echo.
)

REM Port-Verfügbarkeit prüfen
netstat -an | findstr :5173 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    color 0E
    echo [WARNUNG] Port 5173 ist bereits belegt!
    echo.
    echo Moechtest du:
    echo   1) Den blockierenden Prozess beenden
    echo   2) Trotzdem fortfahren (Vite waehlt anderen Port)
    echo   3) Abbrechen
    echo.
    choice /C 123 /N /M "Waehle [1/2/3]: "
    if !ERRORLEVEL! EQU 1 (
        echo [INFO] Beende Prozess auf Port 5173...
        for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173') do (
            taskkill /F /PID %%a >nul 2>&1
        )
        timeout /t 2 /nobreak >nul
        echo [OK] Port 5173 ist jetzt frei!
    ) else if !ERRORLEVEL! EQU 3 (
        echo [INFO] Start abgebrochen.
        pause
        exit /b 0
    )
    echo.
)

echo ==========================================
echo    Starte MusicPad Soundboard...
echo ==========================================
echo.
echo [INFO] Vite Dev Server wird gestartet...
echo [INFO] Die PWA wird verfuegbar sein unter:
echo.
echo        http://localhost:5173
echo.
echo        Lokales Netzwerk: http://%COMPUTERNAME%:5173
echo.
echo ==========================================
echo.
echo Tastenkombinationen:
echo   - STRG+C    = Server beenden
echo   - 'r'+Enter = Server neustarten
echo   - 'h'+Enter = Hilfe anzeigen
echo.
echo ==========================================
echo.

REM Vite Development Server starten
if "%USE_NPM%"=="true" (
    call npm run dev
) else (
    call yarn dev
)

REM Cleanup nach Beendigung
echo.
echo ==========================================
echo [INFO] MusicPad Soundboard wurde beendet.
echo ==========================================
echo.

pause
exit /b 0