# Mesa de Corte Pro — Paquete para Jule

## Contenido
- 📄 PROMPT_PARA_JULE.md  ← Pégale esto a Jule como primer mensaje
- 📁 html_modules/         ← Los 5 archivos HTML de la app
  - index.html             ← Pantalla de inicio
  - trazador-patrones-v6.html
  - nesting-v1.html
  - graduacion-tallas-v1.html
  - calculadora-costos-v1.html

## Pasos
1. Abre Jule
2. Pégale el contenido de PROMPT_PARA_JULE.md
3. Cuando te pida los archivos, sube los 5 HTML de /html_modules/
4. Jule genera el APK listo para instalar en Android

## Notas importantes para Jule
- Cada módulo debe tener su propio WebView aislado
- setAllowFileAccessFromFileURLs(true) es OBLIGATORIO
- El LocalStorage debe persistir entre sesiones
- Orientación landscape solo para el Trazador
