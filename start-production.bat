@echo off
title MusicPad Soundboard - Production Server
color 0B

echo ==========================================
echo   MUSICPAD SOUNDBOARD - PRODUCTION BUILD
echo ==========================================
echo.

REM Projektverzeichnis setzen
set PROJECT_PATH=C:\Projekte\soundboard
cd /d "%PROJECT_PATH%" 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Projektverzeichnis nicht gefunden: %PROJECT_PATH%
    pause
    exit /b 1
)

echo [INFO] Erstelle Production Build...
echo.

REM Dependencies prüfen
if not exist "node_modules\" (
    echo [INFO] Installiere Dependencies...
    call yarn install
    echo.
)

REM Production Build erstellen
call yarn build

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERROR] Build fehlgeschlagen!
    pause
    exit /b 1
)

echo.
echo [OK] Build erfolgreich erstellt!
echo.
echo ==========================================
echo   Starte Production Server...
echo ==========================================
echo.

REM Mit Vite Preview starten (nutzt Port 5173 wie in package.json definiert)
echo [INFO] Server laeuft auf http://localhost:5173
echo.
call yarn preview

pause