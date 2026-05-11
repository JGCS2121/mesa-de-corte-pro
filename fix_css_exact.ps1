$files = @(
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\nesting-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\graduacion-tallas-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\calculadora-costos-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\index.html'
)

$targetCss = @'
  * { margin:0; padding:0; box-sizing:border-box; }
  canvas { touch-action: none; }
  button, .btn, .tool-btn, .mirror-btn, select, input, a {
    touch-action: manipulation;
  }
'@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
        
        # Regex to find the universal selector block and replace it with the exact requested one
        $content = $content -replace '(?m)^\s*\*\s*\{\s*margin\s*:\s*0\s*;\s*padding\s*:\s*0\s*;\s*box-sizing\s*:\s*border-box\s*;\s*\}', $targetCss
        
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated CSS in: $(Split-Path $file -Leaf)"
    }
}
Write-Host "Done!"
