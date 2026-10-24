import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/intent_force_update.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Force-update settings given to `AppSettingDynamicRunApp`.
/// It provides them to the app (Provider) for `AppSettingForceUpdateChecker`.
@immutable
class AppSettingForceUpdateConfig {
  const AppSettingForceUpdateConfig({
    required this.currentVersion,
    required this.linkUpdateApplestore,
    required this.linkUpdateGoogleplay,
    this.title,
    this.message,
    this.button,
    this.fromCache = true,
  });

  /// Version of this build, compared with the min version from firebase.
  final int currentVersion;
  final String linkUpdateApplestore;
  final String linkUpdateGoogleplay;
  final String? title;
  final String? message;
  final String? button;

  /// See `AppSettingDynamicRunApp.forceUpdateFromCache`.
  final bool fromCache;

  bool isNeedForceUpdate(AppSettingDynamicNotifier setting) =>
      setting.isNeedForceUpdate(currentVersion, useCache: fromCache);

  String get linkUpdateForCurrentPlatform =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? linkUpdateApplestore
          : linkUpdateGoogleplay;
}

/// Force-update dialog: the back button can't close it.
class AppSettingForceUpdateDialog extends StatelessWidget {
  const AppSettingForceUpdateDialog({super.key, required this.config});

  final AppSettingForceUpdateConfig config;

  Future<void> _openStore(BuildContext context) async {
    try {
      await IntentForceUpdate.openBrowser(context, config.linkUpdateForCurrentPlatform);
    } catch (e) {
      debugPrint('AppSettingForceUpdateDialog - open store failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent back button dismiss
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// icon
              const SizedBox(height: 10),
              const Icon(Icons.update, size: 180),
              const SizedBox(height: 10),

              /// info
              Text(config.title ?? 'Force Update'),
              const SizedBox(height: 20),
              Text(config.message ?? 'Your Have Old Version, You need to update from store'),
              const SizedBox(height: 40),

              /// update btn
              TextButton(
                onPressed: () => _openStore(context),
                child: Text(config.button ?? 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
