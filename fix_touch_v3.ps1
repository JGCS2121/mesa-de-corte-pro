$file = 'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# Fix 1: Remove touch-action from the * selector entirely
$content = $content -replace '(\*\s*\{[^}]*?)touch-action\s*:\s*\w+\s*;?', '$1'

# Fix 2: Remove ALL previously injected script blocks (cleanup)
$content = $content -replace '(?s)<script>\s*// CRITICAL FIX.*?</script>', ''
$content = $content -replace '(?s)<script>\s*// ={5,}.*?SOPORTE TACTIL.*?</script>', ''
$content = $content -replace '(?s)<script>\s*// Convertir eventos touch.*?</script>', ''

# Fix 3: Remove the old injection before </body> if present and add the clean new one
$content = $content -replace '(?s)<script>\s*// Fix para WebView.*?</script>\s*(?=</body>)', ''

$newScript = @'
<script>
// Fix para WebView Android: asegurar que el canvas superior recibe todos los eventos
(function() {
  function fixCanvases() {
    ['canvas-base','canvas-draw','canvas-ui'].forEach(function(id) {
      var c = document.getElementById(id);
      if (c) {
        c.style.touchAction = 'none';
        c.style.webkitUserSelect = 'none';
      }
    });
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', fixCanvases);
  } else {
    fixCanvases();
  }
})();
</script>
'@

$content = $content -replace '(?i)</body>', ($newScript + '</body>')

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "trazador-patrones-v6.html patched OK"
