# 📦 MusicPad Soundboard - Yarn Installation Guide

## ⚠️ WICHTIGER HINWEIS

Die `App.tsx` Datei im `src` Ordner ist nur ein Platzhalter! Sie muss mit dem vollständigen Code aus der ersten Nachricht ersetzt werden.

## 🚀 Schnellstart mit Yarn

### Automatische Installation (Windows)
Nutze eines der Setup-Skripte:
- **PowerShell**: `./setup.ps1`
- **CMD**: `setup.bat`

Diese Skripte prüfen automatisch alle Voraussetzungen und installieren das Projekt.

## 📋 Manuelle Installation mit Yarn

### Voraussetzungen
- Node.js (v16 oder höher): https://nodejs.org
- Yarn Package Manager: https://yarnpkg.com

#### Yarn installieren (falls noch nicht vorhanden):
```bash
npm install -g yarn
```

### Schritt 1: Projekt extrahieren
1. Entpacke die `soundboard.zip` in dein gewünschtes Verzeichnis (z.B. `C:\Projekte\`)
2. Du solltest folgende Struktur haben:
   ```
   soundboard/
   ├── src/
   │   ├── App.tsx (MUSS ERSETZT WERDEN!)
   │   ├── main.tsx
   │   └── index.css
   ├── public/
   │   └── sw.js
   ├── package.json
   ├── setup.ps1      # PowerShell Setup-Skript
   ├── setup.bat      # Batch Setup-Skript
   ├── vite.config.ts
   └── ...
   ```

### Schritt 2: App.tsx ersetzen
**KRITISCH**: Ersetze den Inhalt von `src/App.tsx` mit dem vollständigen Code aus der ersten Nachricht!

Der vollständige Code beginnt mit:
```typescript
import React, { useEffect, useRef, useState, useCallback } from "react"
import {
  Play, Pause, Settings, X, Download, Upload, ChevronLeft, ChevronRight,
  // ... weitere imports
```

### Schritt 3: Terminal/PowerShell öffnen
```bash
cd C:\Projekte\soundboard
```

### Schritt 4: Dependencies mit Yarn installieren
```bash
yarn install
```

Yarn erstellt automatisch eine `yarn.lock` Datei für konsistente Dependencies.

### Schritt 5: App starten
```bash
yarn dev
```

Die App läuft dann auf: **http://localhost:4174**

## 📦 Yarn-Befehle

| Befehl | Beschreibung |
|--------|-------------|
| `yarn install` | Installiert alle Dependencies |
| `yarn dev` | Startet Entwicklungsserver auf Port 4174 |
| `yarn build` | Erstellt Production Build |
| `yarn preview` | Startet Preview Server auf Port 4174 |
| `yarn serve` | Alias für preview |

## 🚀 Production Deployment

### Build erstellen:
```bash
yarn build
```

### Production Preview:
```bash
yarn preview
```

### Mit PM2 (Process Manager):
```bash
# PM2 global installieren
yarn global add pm2

# Build erstellen
yarn build

# Mit PM2 starten
pm2 start "yarn preview" --name soundboard
pm2 save
pm2 startup
```

## 🔧 Troubleshooting

### "yarn ist nicht als Befehl erkannt"
→ Installiere Yarn global: `npm install -g yarn`

### "App.tsx hat Fehler"
→ Stelle sicher, dass du den KOMPLETTEN Code aus der ersten Nachricht kopiert hast

### "Port 4174 ist belegt"
→ Beende andere Prozesse auf diesem Port oder ändere den Port in `vite.config.ts`

### "MIDI funktioniert nicht"
→ MIDI funktioniert nur in Chrome/Edge Browser

### Dependencies-Fehler
```bash
# Cache leeren und neu installieren
yarn cache clean
rm -rf node_modules yarn.lock
yarn install
```

### Yarn Version aktualisieren
```bash
yarn set version stable
```

## 📁 Wichtige Dateien

- **src/App.tsx**: Hauptkomponente (MUSS mit vollständigem Code ersetzt werden!)
- **package.json**: Dependencies und Scripts
- **yarn.lock**: Yarn Lock-Datei (wird automatisch erstellt)
- **vite.config.ts**: Server-Konfiguration (Port 4174)
- **setup.ps1/setup.bat**: Automatische Setup-Skripte

## ✅ Fertig!

Nach erfolgreicher Installation solltest du ein voll funktionsfähiges Soundboard mit:
- Multi-Channel Audio (8 Kanäle)
- MIDI-Support
- Drag & Drop
- Loop-Modus
- Wellenform-Anzeige
- PWA-Support (installierbar)
- Und vielem mehr!

haben.

---

💡 **Tipp**: Nutze die Setup-Skripte für eine automatische Installation!
