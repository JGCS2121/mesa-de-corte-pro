$files = @(
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\nesting-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\graduacion-tallas-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\calculadora-costos-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\index.html'
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

        # Fix 1: Remove touch-action:none from the universal * selector
        $content = $content -replace '(\*\s*\{[^}]*?)touch-action\s*:\s*none\s*;?', '$1touch-action: auto;'

        # Fix 2: Inject JS-based touch fix right after <head> or <body> opening
        $jsInject = @'
<script>
// CRITICAL FIX: Enable touch events for all interactive elements
document.addEventListener('DOMContentLoaded', function() {
  // Fix touch-action on all interactive elements
  var interactive = document.querySelectorAll('button, a, select, input, textarea, [onclick], .btn, .tool-btn, .mirror-btn, .color-dot, .lib-item, .lib-item-del');
  interactive.forEach(function(el) {
    el.style.touchAction = 'manipulation';
    el.style.webkitUserSelect = 'none';
    el.style.cursor = 'pointer';
  });

  // Fix: ensure canvas elements keep touch-action:none for drawing
  document.querySelectorAll('canvas').forEach(function(c) {
    c.style.touchAction = 'none';
  });

  // Fix: simulate click on touchend for buttons that may not respond
  document.addEventListener('touchend', function(e) {
    var el = e.target;
    while (el && el !== document.body) {
      if (el.tagName === 'BUTTON' || el.hasAttribute('onclick') || el.classList.contains('btn') || el.classList.contains('tool-btn') || el.classList.contains('mirror-btn') || el.classList.contains('color-dot')) {
        e.preventDefault();
        el.click();
        return;
      }
      el = el.parentElement;
    }
  }, { passive: false });
});
</script>
'@

        # Insert after <head> or at beginning of <body>
        if ($content -match '(?i)<head>') {
            $content = $content -replace '(?i)<head>', ('<head>' + $jsInject)
        } elseif ($content -match '(?i)<body') {
            $content = $content -replace '(?i)(<body[^>]*>)', ('$1' + $jsInject)
        }

        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Patched: $(Split-Path $file -Leaf)"
    }
}
Write-Host "All files patched!"
