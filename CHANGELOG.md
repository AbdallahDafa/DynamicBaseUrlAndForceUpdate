## Unreleased

* refactor: `AppSettingDynamicInstaller` replaced by `AppSettingDynamicNotifier` (Provider `ChangeNotifier`)
* `AppSettingDynamicRunApp` provides the notifier to the app with `ChangeNotifierProvider`
* `AppSettingDynamicInstaller` kept as deprecated wrapper
* add dependence `provider`
* BREAKING: `AppSettingDynamicRunApp` doesn't download and doesn't show the force-update screen on the root
  anymore: add `AppSettingForceUpdateCheckerWidget` to your home page
* the download starts only from screens, never from main(): splash screen (optional, don't await it)
  and home page (required, `AppSettingForceUpdateCheckerWidget`), they share the same request
* the splash screen never waits for the network
* cache: the last downloaded setting is saved on the device (`shared_preferences`) and loaded by
  `setConfigBaseUrls()` (now returns `Future`, await it in main before init of dio helper / di)
* `domain` priority: 1- remote response, 2- cache, 3- `domainDefault`;
  new `domainSource`, `remoteResponse`, `cachedResponse`, `clearCache()`
* new widget `AppSettingForceUpdateCheckerWidget` (required in the home page): downloads the app setting and
  checks force update, dialog closes by itself when the new download says no update is needed
* force update is checked offline too, with the cached min version
* `onNeedUpdateDioHelperBaseUrl` is called only when the base url changes
* apps opened offline: failed download is tried again (`download(retryIfFailed: true)`)
  when the home page opens and when the app comes back to the foreground
* add dependence `shared_preferences`
* one import for everything: `package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart`
  now exports the whole public API, no need to import files from `app_setting_dynamic/`

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
