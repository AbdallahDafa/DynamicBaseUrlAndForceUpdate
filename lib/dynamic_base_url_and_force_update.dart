
import 'dynamic_base_url_and_force_update_platform_interface.dart';

class DynamicBaseUrlAndForceUpdate {
  Future<String?> getPlatformVersion() {
    return DynamicBaseUrlAndForceUpdatePlatform.instance.getPlatformVersion();
  }
}
