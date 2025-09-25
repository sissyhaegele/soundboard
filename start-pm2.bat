@echo off
title MusicPad Soundboard - PM2 Manager
color 09

echo ==========================================
echo   MUSICPAD SOUNDBOARD - PM2 PRODUCTION
echo ==========================================
echo.

set PROJECT_PATH=C:\Projekte\soundboard
cd /d "%PROJECT_PATH%"

REM PM2 prüfen (ist in devDependencies)
where pm2 >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] PM2 nicht global installiert, verwende lokale Version...
    set PM2=npx pm2
) else (
    set PM2=pm2
)

:MENU
echo.
echo Was moechtest du tun?
echo.
echo   1) Production Build erstellen und Server starten
echo   2) Server Status anzeigen
echo   3) Server stoppen
echo   4) Server neustarten
echo   5) Logs anzeigen
echo   6) Server komplett entfernen
echo   7) Beenden
echo.
choice /C 1234567 /N /M "Waehle [1-7]: "

if %ERRORLEVEL% EQU 1 goto START
if %ERRORLEVEL% EQU 2 goto STATUS
if %ERRORLEVEL% EQU 3 goto STOP
if %ERRORLEVEL% EQU 4 goto RESTART
if %ERRORLEVEL% EQU 5 goto LOGS
if %ERRORLEVEL% EQU 6 goto DELETE
if %ERRORLEVEL% EQU 7 goto END

:START
echo.
echo [INFO] Erstelle Production Build...
call yarn build
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build fehlgeschlagen!
    pause
    goto MENU
)
echo.
echo [INFO] Starte Server mit PM2...
%PM2% delete musicpad-soundboard >nul 2>&1
%PM2% serve dist 5173 --name musicpad-soundboard --spa
echo.
echo [OK] Server laeuft auf http://localhost:5173
pause
goto MENU

:STATUS
echo.
%PM2% status
pause
goto MENU

:STOP
echo.
echo [INFO] Stoppe Server...
%PM2% stop musicpad-soundboard
pause
goto MENU

:RESTART
echo.
echo [INFO] Starte Server neu...
%PM2% restart musicpad-soundboard
pause
goto MENU

:LOGS
echo.
echo [INFO] Zeige Logs (druecke STRG+C zum Beenden)...
%PM2% logs musicpad-soundboard
goto MENU

:DELETE
echo.
echo [WARNUNG] Server wird komplett aus PM2 entfernt!
choice /C JN /M "Bist du sicher? [J/N]: "
if %ERRORLEVEL% EQU 1 (
    %PM2% delete musicpad-soundboard
    echo [OK] Server wurde entfernt.
)
pause
goto MENU

:END
echo.
echo [INFO] PM2 Manager beendet.
timeout /t 2 /nobreak >nul
exit /b 0