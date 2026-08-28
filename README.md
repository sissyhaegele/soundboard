# Soundboard

Browserbasierte PWA für Live-Sound-Management bei Turnieren und Events:
Multi-Channel-Audio, MIDI-Steuerung, Hotkeys und Drag & Drop.

## Quick Start

```bash
yarn install
yarn dev
```

Der Dev-Server läuft auf http://localhost:5173.

## Scripts

| Befehl | Beschreibung |
| --- | --- |
| `yarn dev` | Entwicklungsserver (Port 5173) |
| `yarn build` | Typecheck + Production-Build nach `dist/` |
| `yarn typecheck` | Nur TypeScript prüfen |
| `yarn preview` | Production-Build lokal ansehen (Port 5000) |

## Features

- **Multi-Channel-Audio** – bis zu 8 Sounds gleichzeitig, alle über einen
  gemeinsamen Web-Audio-Graph
- **Fade-In/Fade-Out** pro Pad, Start-Zeit und Loop einstellbar
- **Audio-Normalisierung** (DynamicsCompressor) zuschaltbar
- **MIDI-Controller-Support** inkl. MIDI-Learn pro Pad (Chrome/Edge)
- **Hotkeys** – 1–9/0 sowie frei belegbare Tasten, Leertaste = Stop All
- **Drag & Drop** zum Umsortieren der Pads
- **Banks** für verschiedene Setups
- **Backup/Restore** als ZIP inkl. Audio-Dateien, mit Konflikt-Strategien
- **Offline-fähig** – Audio-Dateien liegen in IndexedDB, Einstellungen im
  LocalStorage

## Audio-Quellen

Pro Pad stehen drei Quellen zur Verfügung:

- **Lokale Datei** (empfohlen) – wird in IndexedDB gespeichert und funktioniert
  offline
- **URL** – direkter Link auf eine Audio-Datei; der Server muss CORS erlauben
- **Proxy** – Notlösung für URLs ohne CORS-Header. Die Datei läuft dabei über
  einen fremden Server; für den Turnierbetrieb sind lokale Dateien zuverlässiger.

## Technologie

React 18 · TypeScript 5 · Vite 5 · Tailwind CSS 3 · Web Audio API · WebMIDI ·
IndexedDB · JSZip

---

## Copyright

© 2025 Sissy Hägele. Alle Rechte vorbehalten.

Diese Software wurde entwickelt für den Einsatz bei Reitturnieren.
