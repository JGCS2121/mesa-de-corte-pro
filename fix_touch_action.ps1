$files = @(
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\trazador-patrones-v6.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\nesting-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\graduacion-tallas-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\calculadora-costos-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\index.html'
)

$fixCss = @'
/* FIX: restore touch events for interactive elements */
button, .btn, .tool-btn, .mirror-btn, .color-dot,
select, input, textarea, a, label, [onclick] {
  touch-action: manipulation !important;
  cursor: pointer;
}
'@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
        if ($content -match '</style>') {
            $newContent = $content -replace '(?i)</style>', ($fixCss + '</style>')
            [System.IO.File]::WriteAllText($file, $newContent, [System.Text.Encoding]::UTF8)
            Write-Host "Fixed: $file"
        } else {
            Write-Host "WARNING: No closing style tag found in $file"
        }
    } else {
        Write-Host "NOT FOUND: $file"
    }
}
Write-Host "Done!"
