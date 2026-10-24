import 'package:flutter/foundation.dart';

/// Force-update settings given to `AppSettingDynamicRunApp`.
/// It provides them to the app (Provider) for `AppSettingForceUpdateCheckerWidget`.
@immutable
class AppSettingForceUpdateConfig {
  const AppSettingForceUpdateConfig({
    required this.currentVersion,
    required this.linkUpdateApplestore,
    required this.linkUpdateGoogleplay,
    this.title,
    this.message,
    this.button,
  });

  /// Version of this build, compared with the min version from firebase.
  final int currentVersion;
  final String linkUpdateApplestore;
  final String linkUpdateGoogleplay;
  final String? title;
  final String? message;
  final String? button;

  String get linkUpdateForCurrentPlatform =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? linkUpdateApplestore
          : linkUpdateGoogleplay;
}
