Add-Type -AssemblyName System.Drawing

function Create-Icon {
    param([string]$path, [int]$size)
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $bgColor = [System.Drawing.ColorTranslator]::FromHtml('#0d0d1a')
    $g.Clear($bgColor)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $penWidth = [Math]::Max(1.5, $size / 16.0)
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Silver, $penWidth)
    $scale = $size / 108.0
    $p1x = [int](28 * $scale); $p1y = [int](28 * $scale)
    $p2x = [int](80 * $scale); $p2y = [int](80 * $scale)
    $p3x = [int](80 * $scale); $p3y = [int](28 * $scale)
    $p4x = [int](28 * $scale); $p4y = [int](80 * $scale)
    $g.DrawLine($pen, $p1x, $p1y, $p2x, $p2y)
    $g.DrawLine($pen, $p3x, $p3y, $p4x, $p4y)
    $r = [int](9 * $scale)
    $g.DrawEllipse($pen, $p1x - $r, $p1y - $r, $r * 2, $r * 2)
    $g.DrawEllipse($pen, $p4x - $r, $p4y - $r, $r * 2, $r * 2)
    $pen.Dispose()
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: $path ($size x $size)"
}

$base = 'C:\Catali\Mesa de Corte Pro\app\src\main\res'
Create-Icon "$base\mipmap-mdpi\ic_launcher.png" 48
Create-Icon "$base\mipmap-mdpi\ic_launcher_round.png" 48
Create-Icon "$base\mipmap-hdpi\ic_launcher.png" 72
Create-Icon "$base\mipmap-hdpi\ic_launcher_round.png" 72
Create-Icon "$base\mipmap-xhdpi\ic_launcher.png" 96
Create-Icon "$base\mipmap-xhdpi\ic_launcher_round.png" 96
Create-Icon "$base\mipmap-xxhdpi\ic_launcher.png" 144
Create-Icon "$base\mipmap-xxhdpi\ic_launcher_round.png" 144
Create-Icon "$base\mipmap-xxxhdpi\ic_launcher.png" 192
Create-Icon "$base\mipmap-xxxhdpi\ic_launcher_round.png" 192
Write-Host "All icons generated successfully!"
