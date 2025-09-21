@echo off
title Soundboard Dev Server

echo ========================================
echo Soundboard Dev Server - Port 4174
echo ========================================
echo.

:: Port prüfen und ggf. freigeben
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :4174') do (
    echo Port 4174 ist belegt von PID: %%a
    echo Beende Prozess...
    taskkill /F /PID %%a >nul 2>&1
    timeout /t 2 >nul
)

echo Port 4174 ist frei
echo Starte Server...
echo.

yarn dev