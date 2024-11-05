'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "394d39c257e13226ac6c8b2f4db968bb",
"assets/AssetManifest.bin.json": "055f78245947ab4cc516a6571511633f",
"assets/AssetManifest.json": "cc97f0c33b2547f0f7d7677cde6500cf",
"assets/assets/fonts/Face-Off-M54.ttf": "954fd1137171e24fecec143846da487f",
"assets/assets/fonts/Facon.otf": "b86695cd96ce022ba2c1cb98143518c7",
"assets/assets/fonts/Mixcross.otf": "57ba4ddf4c345773c75e7fb3761eddbc",
"assets/assets/fonts/Montserrat-Bold.ttf": "ed86af2ed5bbaf879e9f2ec2e2eac929",
"assets/assets/fonts/Montserrat-Regular.ttf": "5e077c15f6e1d334dd4e9be62b28ac75",
"assets/assets/icons/escudo.png": "05843cceb70e79bbb0a6e33bd8318258",
"assets/assets/icons/escudo1.png": "22dc827ca6068711ced8f866e4c45cf2",
"assets/assets/icons/escudo10.png": "9fcc68c52ac57f81c7179a385fe6932e",
"assets/assets/icons/escudo100.png": "7b8cdbde28a93ea87faf3bf61fd41573",
"assets/assets/icons/escudo101.png": "6b733b8fcc5c55b05c49739f0eb48e81",
"assets/assets/icons/escudo102.png": "ad63023e1672be3fa58dfb72f76be588",
"assets/assets/icons/escudo103.png": "5e0264a3fa2c8a3447bbff924db65d89",
"assets/assets/icons/escudo104.png": "a705411dbe6a7e7be11d538b42810496",
"assets/assets/icons/escudo11.png": "f59be66216a22da89f8a46d942f7fbc3",
"assets/assets/icons/escudo12.png": "b34f1275f4379d854db32dd191555bd2",
"assets/assets/icons/escudo13.png": "556c777dd032306682029f3119082532",
"assets/assets/icons/escudo14.png": "75d3e6273ac31e3ccca0df3f1f77a5de",
"assets/assets/icons/escudo15.png": "3c13e741500335a5add49fc453727004",
"assets/assets/icons/escudo16.png": "bfdec349cdfe1092ac961ab9c61b4b5c",
"assets/assets/icons/escudo17.png": "22c223fb433ab5c39612033e1f3f0461",
"assets/assets/icons/escudo18.png": "4089325c5328cbfd99b7be9e002da39e",
"assets/assets/icons/escudo19.png": "dc9c573c55be19a87fcccc6b36b61ee2",
"assets/assets/icons/escudo2.png": "ad6cdf490d1d8ee4e2024ccaf19e5da7",
"assets/assets/icons/escudo20.png": "3575626f8b34b78d985797a424f1dc56",
"assets/assets/icons/escudo21.png": "53752a30466b27af27fded7d943697d2",
"assets/assets/icons/escudo22.png": "187f0c31a9df7dab438b430dea2b4921",
"assets/assets/icons/escudo23.png": "074473f3b33978b22e3d712d826836d6",
"assets/assets/icons/escudo24.png": "f92f740a663b2703ddbd42a6f541cfee",
"assets/assets/icons/escudo25.png": "b776f942cff5fca6add893c04c375869",
"assets/assets/icons/escudo26.png": "e43b82d128203fba5aef1dcab8179bac",
"assets/assets/icons/escudo27.png": "8ad71512fa2c5b0c6abb6e127f7bb655",
"assets/assets/icons/escudo28.png": "3deaff9629ae23779302a6ba1a1cac8a",
"assets/assets/icons/escudo29.png": "fe9b448ba8e0ad5c9d797272c548d0f8",
"assets/assets/icons/escudo3.png": "72eaddd0b14edc431a8f6b36dead8fb5",
"assets/assets/icons/escudo30.png": "f29cd562202f5c4b78da819273b57b65",
"assets/assets/icons/escudo31.png": "cecae50415d099dcdfe5acc918d7df30",
"assets/assets/icons/escudo32.png": "9dbe02495bfe8e47c282f86def6c68c5",
"assets/assets/icons/escudo33.png": "11a6722bb4915bfe720265dd31dbb8e2",
"assets/assets/icons/escudo34.png": "75b7c6a18e1bb634ad37c6da528e72a0",
"assets/assets/icons/escudo35.png": "f451483acd5f3187f044180c794aefe4",
"assets/assets/icons/escudo36.png": "60101b218a1a0e300df797d1f408f327",
"assets/assets/icons/escudo37.png": "f54321e4f324d541843809f33fe5dfe4",
"assets/assets/icons/escudo38.png": "0b5418a8eda9868b414ac23f25e6d3b7",
"assets/assets/icons/escudo39.png": "3269906824a23567cd9197d2d4ca68d8",
"assets/assets/icons/escudo4.png": "46dc1cab8421f74ab9e4da9918d3dfcb",
"assets/assets/icons/escudo40.png": "930e19b3e12ff96f4316ce6058ef5df1",
"assets/assets/icons/escudo41.png": "73d89435042d07904518bda9497954e3",
"assets/assets/icons/escudo42.png": "421b16f3783961fb27cdf1f014e779df",
"assets/assets/icons/escudo43.png": "6d38da730f0aff76a042cbcde00259e6",
"assets/assets/icons/escudo44.png": "15a2c8f23946a7616374687b8878cfcb",
"assets/assets/icons/escudo45.png": "00236930b618985145ad383728f6826a",
"assets/assets/icons/escudo46.png": "015c3f7542377403af92cafe0126af59",
"assets/assets/icons/escudo47.png": "3c6130422ae8cb553b919708115b1173",
"assets/assets/icons/escudo48.png": "b966b44efafd07bdbe2434a2bce35950",
"assets/assets/icons/escudo49.png": "10496f932816ccb2555e900fb47de449",
"assets/assets/icons/escudo5.png": "39a64648967d315e5904f5bf80c764bb",
"assets/assets/icons/escudo50.png": "a7c68a0a02a544ded945c72eb5433530",
"assets/assets/icons/escudo51.png": "47ec920b8a029b6e0bc1e5fe920bf3c1",
"assets/assets/icons/escudo52.png": "1278310aea858e4301a72c6c7f94ab27",
"assets/assets/icons/escudo53.png": "8750cea43be6a72d20f233520dd3ed09",
"assets/assets/icons/escudo54.png": "e85615f013241c6d80d4b9a535d403d2",
"assets/assets/icons/escudo55.png": "d3fbda8bed11c2bbf9501c5d0451b7ba",
"assets/assets/icons/escudo56.png": "bc45951bd917569d4965e2687fbe3b46",
"assets/assets/icons/escudo57.png": "25f2fe8553ddc3fd3f84528ccbd85a79",
"assets/assets/icons/escudo58.png": "400993c44dd1d07ff27b92be4771cb77",
"assets/assets/icons/escudo59.png": "78117121ef1a6bd51f62290a3a655087",
"assets/assets/icons/escudo6.png": "6f17dddca8c359d74cee1d83ef30b7e6",
"assets/assets/icons/escudo60.png": "2d68f32879a8036f5f1c4150bfe8ab10",
"assets/assets/icons/escudo61.png": "243c76fe60cc4ce748b8ee98fb41472b",
"assets/assets/icons/escudo62.png": "164f54fcdeeac941deeca058915676c7",
"assets/assets/icons/escudo63.png": "f8b9f872bff62e12a9b69090882be0b5",
"assets/assets/icons/escudo64.png": "d2d229f0dbb903865f0f0ca5fc7b52cf",
"assets/assets/icons/escudo65.png": "fa7072087097e85b86000cf8398746f6",
"assets/assets/icons/escudo66.png": "115ac4e58347ddc45c182922102946d3",
"assets/assets/icons/escudo67.png": "243c76fe60cc4ce748b8ee98fb41472b",
"assets/assets/icons/escudo68.png": "31acf5457f2bec13d87d90f1398628b3",
"assets/assets/icons/escudo69.png": "6555c3449f4a76726e2e81d5c553c9a6",
"assets/assets/icons/escudo7.png": "3339cfd4f82b037fb5ddf7ffc77fd37a",
"assets/assets/icons/escudo70.png": "cb33c59f30d0165e9ce724a12ffc7a05",
"assets/assets/icons/escudo71.png": "c38773d89741d9eab849dc0fb69e8af5",
"assets/assets/icons/escudo72.png": "194c5c13d43a76122110629b653b5893",
"assets/assets/icons/escudo73.png": "b91d88cd9cb8c9684e69014e630dea6f",
"assets/assets/icons/escudo74.png": "18da2bf04cab6474f554a409729619e9",
"assets/assets/icons/escudo8.png": "0e1eeaa3727b1842fa109e1d148773cb",
"assets/assets/icons/escudo9.png": "a3088ff0ef7e146a808564f220720b98",
"assets/assets/images/banner.jpg": "c9c74ad1989e9d2aa30ca9635995527b",
"assets/assets/images/copa.webp": "4bab7824c6dc25405aab44d56aa63682",
"assets/assets/images/defecte.png": "60fa6e4a8071280f82b2953fb491722d",
"assets/assets/images/equips.jpg": "d34f24a59f2c0aa05ef810505bb6fa74",
"assets/assets/images/grup.jpg": "8b521fff91889bca76010c981c450e2a",
"assets/assets/images/grups.jpg": "eea9ac29eb160e18161303d21f85bd6c",
"assets/assets/images/img.jpg": "6f3bd13fd22813b92f02040c55b9982a",
"assets/assets/images/jugador.png": "2de860bb02bce8a9e03c73a4eb99feed",
"assets/assets/images/jugador2.jpg": "f8a40f11901c4f3ac8ad130695c778fd",
"assets/assets/images/partits.jpg": "a41fd9838c15d25ffe381cc345ff2018",
"assets/FontManifest.json": "97f4fd8bb80ccdd78b63d1d0d813d5cd",
"assets/fonts/MaterialIcons-Regular.otf": "6f53f1a2570548a71270c7f6f20f7725",
"assets/NOTICES": "07fba000a62441d3097781b91615be2e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "94d267ae3482ffc23f05a6708f2774bf",
"/": "94d267ae3482ffc23f05a6708f2774bf",
"main.dart.js": "a0ac17fdd3eddc0326dbad7cf31050ad",
"manifest.json": "39043d0c8fd2556dc4dc628ecda55a64",
"version.json": "f7c1c70e664711d0397b04113924a443"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
