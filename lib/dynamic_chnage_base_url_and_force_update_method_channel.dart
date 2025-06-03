import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dynamic_chnage_base_url_and_force_update_platform_interface.dart';

/// An implementation of [DynamicChnageBaseUrlAndForceUpdatePlatform] that uses method channels.
class MethodChannelDynamicChnageBaseUrlAndForceUpdate extends DynamicChnageBaseUrlAndForceUpdatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dynamic_chnage_base_url_and_force_update');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
