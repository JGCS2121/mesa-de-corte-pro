$files = @(
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\nesting-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\graduacion-tallas-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\calculadora-costos-v1.html',
    'C:\Catali\Mesa de Corte Pro\app\src\main\assets\index.html'
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
        
        # Remove touch-action from the * selector entirely
        $content = $content -replace '(\*\s*\{[^}]*?)touch-action\s*:\s*\w+\s*;?', '$1'
        
        # Remove any injected script blocks from previous steps to keep it clean
        $content = $content -replace '(?s)<script>\s*// CRITICAL FIX.*?</script>', ''
        
        [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Patched: $(Split-Path $file -Leaf)"
    }
}
Write-Host "All files cleaned up!"
