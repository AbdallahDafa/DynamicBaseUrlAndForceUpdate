import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/data/app_setting_force_update_config.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/intent_force_update.dart';
import 'package:flutter/material.dart';

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
