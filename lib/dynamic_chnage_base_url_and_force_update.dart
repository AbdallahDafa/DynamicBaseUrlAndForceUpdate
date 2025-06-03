
import 'dynamic_chnage_base_url_and_force_update_platform_interface.dart';

class DynamicChnageBaseUrlAndForceUpdate {
  Future<String?> getPlatformVersion() {
    return DynamicChnageBaseUrlAndForceUpdatePlatform.instance.getPlatformVersion();
  }
}
