package com.mesadecorte.pro;

import android.app.AlertDialog;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    private FrameLayout webViewContainer;
    private BottomNavigationView bottomNavigation;
    private Map<Integer, WebView> webViews = new HashMap<>();
    private int currentTabId = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        webViewContainer = findViewById(R.id.webview_container);
        bottomNavigation = findViewById(R.id.bottom_navigation);

        setupWebViews();

        bottomNavigation.setOnItemSelectedListener(item -> {
            switchTab(item.getItemId());
            return true;
        });

        // Cargar pestaña inicial
        switchTab(R.id.nav_home);
    }

    private void setupWebViews() {
        // Inicializamos los 5 módulos solicitados
        addWebView(R.id.nav_home, "index.html");
        addWebView(R.id.nav_trazador, "trazador-patrones-v6.html");
        addWebView(R.id.nav_nesting, "nesting-v1.html");
        addWebView(R.id.nav_tallas, "graduacion-tallas-v1.html");
        addWebView(R.id.nav_costos, "calculadora-costos-v1.html");
    }

    private void addWebView(int id, String fileName) {
        WebView webView = new WebView(this);
        webView.setLayoutParams(new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT));
        
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccessFromFileURLs(true);
        settings.setAllowUniversalAccessFromFileURLs(true);
        settings.setUseWideViewPort(true);
        settings.setLoadWithOverviewMode(true);
        settings.setBuiltInZoomControls(false);
        settings.setDisplayZoomControls(false);

        // Permitir ejecución de JS local
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);

        webView.setWebViewClient(new WebViewClient());
        webView.setFocusable(true);
        webView.setFocusableInTouchMode(true);
        webView.requestFocus();
        webView.setOnTouchListener((v, event) -> {
            if (!v.hasFocus()) v.requestFocus();
            return false;
        });
        webView.loadUrl("file:///android_asset/" + fileName);
        webView.setVisibility(View.GONE);

        webViewContainer.addView(webView);
        webViews.put(id, webView);
    }

    private void switchTab(int id) {
        if (currentTabId == id) return;

        // Ocultar actual
        if (currentTabId != -1) {
            webViews.get(currentTabId).setVisibility(View.GONE);
        }

        // Mostrar nuevo
        WebView nextWebView = webViews.get(id);
        if (nextWebView != null) {
            nextWebView.setVisibility(View.VISIBLE);
            currentTabId = id;

            // Gestión de Orientación según el módulo
            if (id == R.id.nav_trazador) {
                // El trazador permite rotación libre
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
            } else {
                // El resto de la app es solo vertical
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
            }
        }
    }

    @Override
    public void onBackPressed() {
        WebView currentWebView = webViews.get(currentTabId);
        if (currentWebView != null && currentWebView.canGoBack()) {
            currentWebView.goBack();
        } else {
            showExitConfirmation();
        }
    }

    private void showExitConfirmation() {
        new AlertDialog.Builder(this)
                .setTitle("Salir")
                .setMessage("¿Estás seguro de que quieres cerrar la aplicación?")
                .setPositiveButton("Sí", (dialog, which) -> finish())
                .setNegativeButton("No", null)
                .show();
    }
}
