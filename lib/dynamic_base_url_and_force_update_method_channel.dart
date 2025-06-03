import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dynamic_base_url_and_force_update_platform_interface.dart';

/// An implementation of [DynamicBaseUrlAndForceUpdatePlatform] that uses method channels.
class MethodChannelDynamicBaseUrlAndForceUpdate extends DynamicBaseUrlAndForceUpdatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dynamic_base_url_and_force_update');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
