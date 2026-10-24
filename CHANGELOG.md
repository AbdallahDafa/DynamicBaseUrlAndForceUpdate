## Unreleased

* refactor: `AppSettingDynamicInstaller` replaced by `AppSettingDynamicNotifier` (Provider `ChangeNotifier`)
* `AppSettingDynamicRunApp` provides the notifier to the app with `ChangeNotifierProvider`
* `AppSettingDynamicInstaller` kept as deprecated wrapper
* add dependence `provider`
* the splash screen never waits for the network: `download()` runs in background, don't await it
* cache: the last downloaded setting is saved on the device (`shared_preferences`) and loaded by
  `setConfigBaseUrls()` (now returns `Future`, await it in main before init of dio helper / di)
* `domain` priority: 1- remote response, 2- cache, 3- `domainDefault`;
  new `domainSource`, `remoteResponse`, `cachedResponse`, `clearCache()`
* new widget `AppSettingForceUpdateChecker`: force update checked inside the home page,
  dialog closes by itself when the new download says no update is needed
* `AppSettingDynamicRunApp`: new `checkForceUpdateOnRoot` (default `true`) and `forceUpdateFromCache` (default `true`)
* `onNeedUpdateDioHelperBaseUrl` is called only when the base url changes
* apps opened offline: failed download is tried again (`download(retryIfFailed: true)`)
  when the home page opens and when the app comes back to the foreground
* add dependence `shared_preferences`

## 1.0.7

* add in realtime database key :       "min_version_web": 116 
* make dependence 'web: any '

## 1.0.5

* make working on website flutter
* update dependence " web: 1.0.0"

## 1.0.4

* Update Readme
* Fix Bugs .
 
## 1.0.0

* First version .
