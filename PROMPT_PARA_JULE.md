# 📱 PROMPT PARA JULE — App Android "Mesa de Corte Pro"

## ¿Qué necesito?
Convertir una carpeta de archivos HTML en una **app Android nativa (APK)** llamada **"Mesa de Corte Pro"**.

---

## Estructura de archivos
```
/assets/
  index.html                  ← pantalla de inicio con 4 botones
  trazador-patrones-v6.html   ← módulo principal: dibujar patrones
  nesting-v1.html             ← optimizador de tela
  graduacion-tallas-v1.html  ← tabla de tallas 4-20
  calculadora-costos-v1.html ← calculadora de costos y precios
```

---

## Requisitos técnicos Android

### WebView (crítico)
```java
webView.getSettings().setJavaScriptEnabled(true);
webView.getSettings().setDomStorageEnabled(true);
webView.getSettings().setAllowFileAccessFromFileURLs(true);
webView.getSettings().setAllowUniversalAccessFromFileURLs(true);
webView.getSettings().setUseWideViewPort(true);
webView.getSettings().setLoadWithOverviewMode(true);
webView.getSettings().setBuiltInZoomControls(false);
webView.getSettings().setDisplayZoomControls(false);
// Cargar desde assets:
webView.loadUrl("file:///android_asset/index.html");
```

### Navegación
- **BottomNavigationView** nativa con 5 tabs:
  - 🏠 Inicio → index.html
  - ✏️ Trazador → trazador-patrones-v6.html
  - 🧵 Nesting → nesting-v1.html
  - 📐 Tallas → graduacion-tallas-v1.html
  - 💰 Costos → calculadora-costos-v1.html
- Cada tab mantiene su propio WebView en memoria (NO recrear al cambiar tab)
- Back button del Android cierra la app con confirmación

### Permisos en AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Orientación
- Por defecto: **portrait**
- Módulo Trazador: permitir **landscape** también
- `android:configChanges="orientation|screenSize"` para evitar reload

### Otros
- `minSdkVersion 24` (Android 7+)
- `targetSdkVersion 34`
- Nombre paquete: `com.mesadecorte.pro`
- App name: "Mesa de Corte Pro"
- Icono: tijeras ✂️ sobre fondo #0d0d1a (azul muy oscuro)
- Tema: `Theme.AppCompat.NoActionBar` (sin barra de título nativa)
- StatusBar color: `#0d0d1a`
- NavigationBar color: `#0a0a14`
- Funciona **100% offline** — todos los assets van en /assets/

---

## Comportamiento esperado
1. Al abrir la app → pantalla de inicio con los 4 módulos
2. Al tocar "Trazador" → abre el canvas táctil para dibujar patrones
3. Botón "📐 Calibrar" → modal con cuadrado 20×20 cm ajustable para calibrar el proyector Y300
4. Botón "📽️ Proyectar" → abre WebView en pantalla completa sin UI para el proyector
5. LocalStorage se mantiene entre sesiones (patrones guardados, historial de costos)

---

## Archivos incluidos en este ZIP
Todos los HTML están en la carpeta `/html_modules/` del zip.
Cópialos a `/app/src/main/assets/` del proyecto Android.

---

Gracias! 🙏
