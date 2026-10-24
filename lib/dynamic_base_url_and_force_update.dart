/// Dynamic base url and force update.
///
/// One import gives the app everything:
/// ```dart
/// import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';
/// ```
library;

import 'dynamic_base_url_and_force_update_platform_interface.dart';

// data
export 'app_setting_dynamic/data/app_setting_firebase_dynamic_response.dart';
export 'app_setting_dynamic/data/app_setting_force_update_config.dart';

// logic
export 'app_setting_dynamic/logic/app_setting_dynamic_installer.dart'; // deprecated, kept for old apps
export 'app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';

// presentation
export 'app_setting_dynamic/presentation/app_setting_dynamic_run_app.dart';
export 'app_setting_dynamic/presentation/app_setting_force_update_checker_widget.dart';
export 'app_setting_dynamic/presentation/app_setting_force_update_dialog.dart';

class DynamicBaseUrlAndForceUpdate {
  Future<String?> getPlatformVersion() {
    return DynamicBaseUrlAndForceUpdatePlatform.instance.getPlatformVersion();
  }
}
