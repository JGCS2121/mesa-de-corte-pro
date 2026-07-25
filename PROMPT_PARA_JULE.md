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

### ⚠️ CRÍTICO — Permisos de cámara para WebView (getUserMedia)
El módulo de escaneo usa `navigator.mediaDevices.getUserMedia()`. Para que funcione en Android WebView es OBLIGATORIO implementar `WebChromeClient` así:

```java
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        // Permite acceso a cámara y micrófono desde el WebView
        request.grant(request.getResources());
    }
});
```

Sin este código, la cámara nunca funcionará aunque el permiso esté en el Manifest.

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
<uses-feature android:name="android.hardware.camera" android:required="false"/>
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
1. Al abrir la app → pantalla de inicio con tarjeta destacada "📷 Escanear Patrón" + 4 módulos
2. Al tocar "Trazador" → abre el canvas táctil para dibujar patrones
3. En la barra de herramientas del Trazador → botón "📷 Escanear" (color violeta)
4. Al tocar "📷 Escanear" → abre la cámara trasera del celular en vivo
5. Al capturar la foto → dos opciones:
   - **Fase 1**: colocar foto como referencia (45% opacidad) para trazar encima
   - **Fase 2**: detectar bordes automáticamente (algoritmo Sobel en JS) y colocar las líneas
6. Botón "📐 Calibrar" → modal con cuadrado 20×20 cm ajustable para calibrar el proyector Y300
7. Botón "📽️ Proyectar" → abre WebView en pantalla completa sin UI para el proyector
8. LocalStorage se mantiene entre sesiones (patrones guardados, historial de costos)

---

## Archivos incluidos en este ZIP
Todos los HTML están en la raíz del zip.
Cópialos a `/app/src/main/assets/` del proyecto Android.

---

Gracias! 🙏
