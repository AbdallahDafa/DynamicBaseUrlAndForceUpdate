import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'dynamic_base_url_and_force_update_platform_interface.dart';

/// A web implementation of the DynamicBaseUrlAndForceUpdatePlatform of the DynamicBaseUrlAndForceUpdate plugin.
class DynamicBaseUrlAndForceUpdateWeb
    extends DynamicBaseUrlAndForceUpdatePlatform {
  /// Constructs a DynamicBaseUrlAndForceUpdateWeb
  DynamicBaseUrlAndForceUpdateWeb();

  /// Registers this class as the default instance of
  /// [DynamicBaseUrlAndForceUpdatePlatform] on the web.
  static void registerWith(Registrar registrar) {
    DynamicBaseUrlAndForceUpdatePlatform.instance =
        DynamicBaseUrlAndForceUpdateWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
