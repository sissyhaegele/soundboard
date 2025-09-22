# Service Worker Soft-Cleanup
Write-Host "Service Worker Cleanup" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

# HTML-Datei für Browser-Cleanup erstellen
$cleanupHtml = @"
<!DOCTYPE html>
<html>
<head>
    <title>Service Worker Cleanup</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #1a1a1a; color: #fff; }
        button { padding: 15px 30px; margin: 10px; font-size: 18px; cursor: pointer; background: #ff6b35; color: white; border: none; border-radius: 5px; }
        button:hover { background: #ff5722; }
        .success { color: #4ade80; margin: 10px 0; }
        #log { margin-top: 20px; padding: 15px; background: #262626; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Soundboard Service Worker Cleanup</h1>
    
    <button onclick="cleanupAll()">Cleanup durchführen</button>
    <button onclick="window.location.href='http://localhost:4174'">Zur App</button>
    
    <div id="log"></div>
    
    <script>
        function log(msg, isSuccess = false) {
            const logDiv = document.getElementById('log');
            const entry = document.createElement('div');
            if (isSuccess) entry.className = 'success';
            entry.textContent = new Date().toLocaleTimeString() + ' - ' + msg;
            logDiv.appendChild(entry);
        }
        
        async function cleanupAll() {
            log('Starte Cleanup...');
            
            try {
                const registrations = await navigator.serviceWorker.getRegistrations();
                for (let registration of registrations) {
                    await registration.unregister();
                    log('Service Worker entfernt: ' + registration.scope, true);
                }
                if (registrations.length === 0) {
                    log('Keine Service Worker gefunden');
                }
            } catch (error) {
                log('Fehler: ' + error);
            }
            
            try {
                const cacheNames = await caches.keys();
                for (let name of cacheNames) {
                    await caches.delete(name);
                    log('Cache gelöscht: ' + name, true);
                }
                if (cacheNames.length === 0) {
                    log('Keine Caches gefunden');
                }
            } catch (error) {
                log('Cache-Fehler: ' + error);
            }
            
            log('Cleanup abgeschlossen! Lade Seite neu...', true);
            setTimeout(() => {
                window.location.href = 'http://localhost:4174';
            }, 2000);
        }
    </script>
</body>
</html>
"@

$cleanupHtml | Out-File -FilePath "cleanup.html" -Encoding UTF8
Write-Host "cleanup.html erstellt" -ForegroundColor Green

# Öffne im Browser
$htmlPath = "$PWD\cleanup.html"
Start-Process $htmlPath