// Compatibility shim for generated registrant which expects the misspelled web plugin file/class.
// This file forwards registration to the real implementation in
// `dynamic_base_url_and_force_update_web.dart`.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dynamic_base_url_and_force_update_web.dart';

/// Backwards-compatible wrapper expected by older generated registrants.
class DynamicChnageBaseUrlAndForceUpdateWeb {
  /// Forwards the registration to [DynamicBaseUrlAndForceUpdateWeb].
  static void registerWith(Registrar registrar) {
    DynamicBaseUrlAndForceUpdateWeb.registerWith(registrar);
  }
}
