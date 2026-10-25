## 1.0.9

* license changed to MIT (an OSI-approved open-source license)
* dependencies have version ranges instead of `any`: `web: ^1.0.0`, `dio: ^5.4.0`, `url_launcher: ^6.2.1`,
  `provider: ^6.0.0`, `shared_preferences: ^2.0.0` (minimum Flutter 3.22, same as the Dart 3.4 minimum)
* iOS & macOS: Swift Package Manager support (`Package.swift` in `ios/dynamic_base_url_and_force_update/`
  and `macos/dynamic_base_url_and_force_update/`)
* iOS & macOS: podspec renamed to `dynamic_base_url_and_force_update.podspec`, so CocoaPods finds the plugin
* Linux & Windows: CMake target and `include/` folder renamed to `dynamic_base_url_and_force_update`, so apps build
* fix `getPlatformVersion()`: the method channel name now matches the native code
* fix analyzer warnings and lints (unused import, dead code), code formatted with `dart format`
* `LocalLog` prints with `debugPrint`

## 1.0.8

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
* BREAKING: `AppSettingDynamicResponse` renamed to `AppSettingFirebaseDynamicResponse`
  (file `app_setting_dynamic/data/app_setting_firebase_dynamic_response.dart`)
* BREAKING: files moved: `intent_force_update.dart` to `app_setting_dynamic/helper/`,
  `log/local_log.dart` to `app_setting_dynamic/logic/` (use the one import above)
* new `AppSettingForceUpdateDialog` and `AppSettingForceUpdateConfig`
* new in the notifier: `status` (`AppSettingDynamicStatus`), `isNeedForceUpdate()`,
  `timeout` (default 8 seconds)
* the download never throws: on no internet / timeout / bad data the app keeps the cache or `domainDefault`
* new `DynamicBaseUrlAndForceUpdate().getPluginDateLastEdition()`: date of the last plugin update
* update README and example

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
