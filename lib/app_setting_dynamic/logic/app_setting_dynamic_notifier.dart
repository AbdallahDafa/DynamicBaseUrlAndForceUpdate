import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/data/app_setting_dynamic_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State of downloading the app setting from firebase.
enum AppSettingDynamicStatus {
  /// `download()` not called yet.
  initial,

  /// Request in progress.
  loading,

  /// Downloaded: dynamic base url + min versions are available (and cached).
  loaded,

  /// No internet / timeout / bad data: the app keeps working with the
  /// cached setting, or `domainDefault` when nothing is cached.
  failed,
}

/// Where [AppSettingDynamicNotifier.domain] comes from right now.
enum AppSettingDomainSource {
  /// 1- downloaded from firebase in this session.
  remote,

  /// 2- last successful download, saved on the device.
  cache,

  /// 3- `domainDefault` passed to `setConfigBaseUrls()`.
  domainDefault,
}

/// App setting dynamic as a Provider `ChangeNotifier`:
///   >>> base url dynamic
///   >>> min version to force update
///
/// The app never waits for the network: the last downloaded setting is saved
/// on the device and used from the first frame (even offline), and the new
/// download updates it in background.
///
/// ----------------------- how to use
///
/// 1- inside main(), before runApp() and before init of dio helper / di:
/// ```dart
/// await AppSettingDynamicNotifier.instance.setConfigBaseUrls(
///   domainDefault: 'https://test4.maqsafy.com',
///   firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app",
/// );
/// ```
///
/// 2- wrap your app with `AppSettingDynamicRunApp(...)`, it provides this
///    notifier to the widget tree with `ChangeNotifierProvider`.
///
/// 3- in the splash screen start the download, DON'T await it:
/// ```dart
/// context.read<AppSettingDynamicNotifier>().download();
/// ```
///
/// 4- in the home page: `AppSettingForceUpdateChecker(child: ...)`.
///
/// 5- in code without BuildContext (dio helper, di, endpoints):
/// ```dart
/// AppSettingDynamicNotifier.instance.domain
/// ```
class AppSettingDynamicNotifier extends ChangeNotifier {
  AppSettingDynamicNotifier._();

  /// One shared instance, so the same state is reached from widgets
  /// (through Provider) and from code that has no BuildContext.
  static final AppSettingDynamicNotifier instance = AppSettingDynamicNotifier._();

  ///------------------------------------------------------------------ config

  String? _domainDefault;
  String? _firebaseBaseUrl;

  /// Max time of the background download. Nothing waits for it: the app
  /// keeps working with the cache / [domainDefault] meanwhile.
  Duration timeout = const Duration(seconds: 8);

  /// example: 'https://test4.maqsafy.com'
  String? get domainDefault => _domainDefault;

  /// example: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app"
  String? get firebaseBaseUrl => _firebaseBaseUrl;

  /// Call in main() before runApp() and before init of dio helper / di,
  /// and await it:
  ///
  /// it also loads the last downloaded setting saved on the device
  /// (a local read, no network), so [domain] is ready before the first
  /// api call, even when the app is opened offline.
  Future<void> setConfigBaseUrls({
    required String domainDefault,
    required String firebaseBaseUrl,
  }) async {
    // other firebase project (example: other flavor) -> other cache
    if (_firebaseBaseUrl != firebaseBaseUrl) _cachedResponse = null;
    _domainDefault = domainDefault;
    _firebaseBaseUrl = firebaseBaseUrl;
    await _loadCache();
  }

  ///------------------------------------------------------------------ state

  AppSettingDynamicStatus _status = AppSettingDynamicStatus.initial;
  AppSettingDynamicResponse? _remoteResponse;
  AppSettingDynamicResponse? _cachedResponse;
  Future<AppSettingDynamicResponse?>? _downloadFuture;

  /// State of the download from firebase (the cache is not a download).
  AppSettingDynamicStatus get status => _status;

  /// Downloaded from firebase in this session.
  /// `null` until downloaded, or when the download failed.
  AppSettingDynamicResponse? get remoteResponse => _remoteResponse;

  /// Last successful download saved on the device.
  /// `null` when nothing was ever downloaded on this device.
  AppSettingDynamicResponse? get cachedResponse => _cachedResponse;

  /// Best setting available right now: [remoteResponse], else [cachedResponse].
  AppSettingDynamicResponse? get response => _remoteResponse ?? _cachedResponse;

  bool get isLoading => _status == AppSettingDynamicStatus.loading;

  /// True once the download finished, with success or failure.
  bool get isCompleteDownloadData =>
      _status == AppSettingDynamicStatus.loaded ||
      _status == AppSettingDynamicStatus.failed;

  /// Base url, by priority:
  ///   1- remote response (downloaded in this session), if found
  ///   2- cache (last download saved on the device), if found
  ///   3- [domainDefault] written in setConfigBaseUrls()
  ///
  /// Sync, never waits for the network.
  String get domain {
    final remote = _remoteResponse?.baseUrlDynamic;
    if (remote != null && remote.isNotEmpty) return remote;
    final cached = _cachedResponse?.baseUrlDynamic;
    if (cached != null && cached.isNotEmpty) return cached;
    return _domainDefault ?? '';
  }

  /// Where [domain] comes from right now.
  AppSettingDomainSource get domainSource {
    final remote = _remoteResponse?.baseUrlDynamic;
    if (remote != null && remote.isNotEmpty) return AppSettingDomainSource.remote;
    final cached = _cachedResponse?.baseUrlDynamic;
    if (cached != null && cached.isNotEmpty) return AppSettingDomainSource.cache;
    return AppSettingDomainSource.domainDefault;
  }

  ///------------------------------------------------------------------ force update

  /// In case not valid, means it needs to force update.
  ///
  /// [useCache] true: before the download finishes (or offline) the cached
  /// min version is used. false: only a download of this session counts.
  bool isValidVersionMinAllowed(int currentVersion, {bool useCache = true}) {
    final minAllowed = _minVersionForCurrentPlatform(useCache: useCache);
    if (minAllowed == null) return true;
    return currentVersion >= minAllowed;
  }

  bool isNeedForceUpdate(int currentVersion, {bool useCache = true}) =>
      !isValidVersionMinAllowed(currentVersion, useCache: useCache);

  int? _minVersionForCurrentPlatform({required bool useCache}) {
    final setting = useCache ? response : _remoteResponse;
    if (setting == null) return null;
    if (kIsWeb) return setting.minVersionWeb;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return setting.minVersionAndroid;
      case TargetPlatform.iOS:
        return setting.minVersionIos;
      default:
        return null;
    }
  }

  ///------------------------------------------------------------------ download

  /// Starts the download in background. Don't await it in the splash screen:
  /// the app keeps working with the cache / [domainDefault], and listeners
  /// are notified when it finishes.
  ///
  /// Downloads once: the splash screen, the run-app and the home page can all
  /// call it, they share the same request.
  /// [retryIfFailed] true: downloads again when the last try failed
  /// (example: the app was opened offline).
  ///
  /// Never throws, never hangs: on no internet / timeout / bad data it
  /// completes with `null` and the cache stays as it is.
  Future<AppSettingDynamicResponse?> download({bool retryIfFailed = false}) {
    if (retryIfFailed && _status == AppSettingDynamicStatus.failed) {
      _downloadFuture = null;
    }
    return _downloadFuture ??= _downloadSettingData();
  }

  Future<AppSettingDynamicResponse?> _downloadSettingData() async {
    // no notifyListeners() here: download() may be called from initState()
    _status = AppSettingDynamicStatus.loading;

    // let the current frame finish before notifyListeners() below
    await Future<void>.delayed(Duration.zero);

    AppSettingDynamicResponse? result;
    Dio? dio;
    try {
      final firebaseBaseUrl = _firebaseBaseUrl;
      if (firebaseBaseUrl == null || firebaseBaseUrl.isEmpty) {
        throw StateError('call setConfigBaseUrls() before download()');
      }
      dio = Dio(BaseOptions(
        connectTimeout: timeout,
        sendTimeout: timeout,
        receiveTimeout: timeout,
      ));
      final responseDio = await dio
          .get('$firebaseBaseUrl/app_setting.json')
          .timeout(timeout); // hard limit (covers DNS hangs)
      final data = responseDio.data;
      if (data is Map) {
        result = AppSettingDynamicResponse.fromJson(
            Map<String, dynamic>.from(data));
      } else {
        debugPrint('AppSettingDynamicNotifier - download() - unexpected data: $data');
      }
    } catch (e) {
      // no internet, timeout, firebase error... -> keep cache / domainDefault
      debugPrint('AppSettingDynamicNotifier - download() - failed: $e');
    } finally {
      dio?.close(force: true); // also cancels a request stopped by timeout
    }

    if (result != null) {
      _remoteResponse = result;
      await _saveCache(result);
    }
    _status = result == null
        ? AppSettingDynamicStatus.failed
        : AppSettingDynamicStatus.loaded;
    debugPrint('AppSettingDynamicNotifier - download() - $_status - $_remoteResponse');
    notifyListeners();
    return result;
  }

  ///------------------------------------------------------------------ cache

  String get _cacheKey => 'app_setting_dynamic_cache:${_firebaseBaseUrl ?? ''}';

  Future<void> _loadCache() async {
    try {
      // shared_preferences needs the binding (main() may not have called it)
      WidgetsFlutterBinding.ensureInitialized();
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      // a download that already finished (and saved) is newer than this read
      if (_remoteResponse != null) return;
      _cachedResponse = AppSettingDynamicResponse.fromJson(
          Map<String, dynamic>.from(decoded));
      debugPrint('AppSettingDynamicNotifier - cache loaded - $_cachedResponse');
      notifyListeners();
    } catch (e) {
      debugPrint('AppSettingDynamicNotifier - read cache failed: $e');
    }
  }

  Future<void> _saveCache(AppSettingDynamicResponse setting) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await prefs.setString(_cacheKey, jsonEncode(setting.toJson()));
      if (saved) _cachedResponse = setting;
    } catch (e) {
      debugPrint('AppSettingDynamicNotifier - save cache failed: $e');
    }
  }

  /// Removes the setting saved on the device (example: for testing).
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (e) {
      debugPrint('AppSettingDynamicNotifier - clear cache failed: $e');
    }
    _cachedResponse = null;
    notifyListeners();
  }
}
