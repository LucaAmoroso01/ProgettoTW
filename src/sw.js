const cacheName = "pwa_f1universe_2023";
let filesToCache = [];

self.addEventListener("install", function (e) {
  e.waitUntil(
    fetch("../src")
      .then(function (response) {
        return response.json();
      })
      .then(function (filesInSrc) {
        filesInSrc = filesInSrc.filter(function (file) {
          return !file.includes("server/");
        });

        filesToCache = filesToCache.concat(filesInSrc);

        return caches.open(cacheName);
      })
      .then(function (cache) {
        return cache.addAll(filesToCache);
      })
  );
});

self.addEventListener("fetch", function (e) {
  e.respondWith(
    caches.match(e.request).then(function (response) {
      return response || fetch(e.request);
    })
  );
});
