import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dynamic_chnage_base_url_and_force_update_method_channel.dart';

abstract class DynamicChnageBaseUrlAndForceUpdatePlatform extends PlatformInterface {
  /// Constructs a DynamicChnageBaseUrlAndForceUpdatePlatform.
  DynamicChnageBaseUrlAndForceUpdatePlatform() : super(token: _token);

  static final Object _token = Object();

  static DynamicChnageBaseUrlAndForceUpdatePlatform _instance = MethodChannelDynamicChnageBaseUrlAndForceUpdate();

  /// The default instance of [DynamicChnageBaseUrlAndForceUpdatePlatform] to use.
  ///
  /// Defaults to [MethodChannelDynamicChnageBaseUrlAndForceUpdate].
  static DynamicChnageBaseUrlAndForceUpdatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DynamicChnageBaseUrlAndForceUpdatePlatform] when
  /// they register themselves.
  static set instance(DynamicChnageBaseUrlAndForceUpdatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
