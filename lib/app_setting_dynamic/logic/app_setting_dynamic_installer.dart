import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/data/app_setting_dynamic_response.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:flutter/foundation.dart';

/// Call back with result.
typedef AppSettingResultOnComplete = Function(AppSettingDynamicResponse? response);

/// Old static API, kept only so existing apps keep compiling.
/// Everything forwards to [AppSettingDynamicNotifier.instance].
@Deprecated(
  'Use AppSettingDynamicNotifier.instance, or '
  'context.read<AppSettingDynamicNotifier>() / context.watch<AppSettingDynamicNotifier>()',
)
class AppSettingDynamicInstaller {
  AppSettingDynamicInstaller._();

  static AppSettingDynamicNotifier get _notifier => AppSettingDynamicNotifier.instance;

  static String? get domainDefault => _notifier.domainDefault;
  static String? get firebaseBaseUrl => _notifier.firebaseBaseUrl;

  static Duration get timeout => _notifier.timeout;
  static set timeout(Duration value) => _notifier.timeout = value;

  static Future<void> setConfigBaseUrls({
    required String domainDefault,
    required String firebaseBaseUrl,
  }) =>
      _notifier.setConfigBaseUrls(
        domainDefault: domainDefault,
        firebaseBaseUrl: firebaseBaseUrl,
      );

  static Future<AppSettingDynamicResponse?> download() => _notifier.download();

  static bool isCompleteDownloadData() => _notifier.isCompleteDownloadData;

  static bool isValidVersionMinAllowed(int currentVersion) =>
      _notifier.isValidVersionMinAllowed(currentVersion);

  static String getDomain() => _notifier.domain;

  static VoidCallback? _splashListener;
  static VoidCallback? _runAppListener;

  static Future addOnCompleteSplash(AppSettingResultOnComplete onComplete) async {
    _splashListener = _replaceListener(_splashListener, onComplete);
  }

  static Future addOnCompleteRunApp(AppSettingResultOnComplete onComplete) async {
    _runAppListener = _replaceListener(_runAppListener, onComplete);
  }

  /// same behaviour as before: one callback per slot, called right away
  /// when the download already completed, otherwise when it completes.
  static VoidCallback _replaceListener(
    VoidCallback? oldListener,
    AppSettingResultOnComplete onComplete,
  ) {
    if (oldListener != null) _notifier.removeListener(oldListener);
    if (_notifier.isCompleteDownloadData) onComplete(_notifier.response);
    void listener() {
      if (_notifier.isCompleteDownloadData) onComplete(_notifier.response);
    }
    _notifier.addListener(listener);
    return listener;
  }
}
