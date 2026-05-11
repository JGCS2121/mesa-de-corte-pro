$content = Get-Content 'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html' -Raw -Encoding UTF8

$touchCode = @'
<script>
// =====================================================
// SOPORTE TACTIL COMPLETO PARA CANVAS Y BOTONES
// =====================================================
(function() {
  function addTouchSupport(canvas) {
    function touchHandler(event) {
      event.preventDefault();
      var touch = event.changedTouches[0];
      var typeMap = { touchstart: 'mousedown', touchmove: 'mousemove', touchend: 'mouseup' };
      var mouseEvent = new MouseEvent(typeMap[event.type], {
        bubbles: true,
        cancelable: true,
        view: window,
        clientX: touch.clientX,
        clientY: touch.clientY
      });
      touch.target.dispatchEvent(mouseEvent);
    }
    canvas.addEventListener('touchstart', touchHandler, { passive: false });
    canvas.addEventListener('touchmove', touchHandler, { passive: false });
    canvas.addEventListener('touchend', touchHandler, { passive: false });
  }
  function applyToAll() {
    document.querySelectorAll('canvas').forEach(addTouchSupport);
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', applyToAll);
  } else {
    applyToAll();
  }
})();
</script>
'@

# Insert before </body>
$newContent = $content -replace '(?i)</body>', ($touchCode + '</body>')

[System.IO.File]::WriteAllText(
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html',
    $newContent,
    [System.Text.Encoding]::UTF8
)
Write-Host "Touch support injected before closing body tag!"
