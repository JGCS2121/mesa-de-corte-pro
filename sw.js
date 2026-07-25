const CACHE_NAME = 'mesa-corte-v1';
const urlsToCache = [
  '/mesa-de-corte-pro/',
  '/mesa-de-corte-pro/index.html',
  '/mesa-de-corte-pro/manifest.json',
  '/mesa-de-corte-pro/html_modules/trazador-patrones-v6.html',
  '/mesa-de-corte-pro/html_modules/nesting-v1.html',
  '/mesa-de-corte-pro/html_modules/graduacion-tallas-v1.html',
  '/mesa-de-corte-pro/html_modules/calculadora-costos-v1.html',
  '/mesa-de-corte-pro/html_modules/index.html'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
