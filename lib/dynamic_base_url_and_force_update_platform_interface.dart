import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dynamic_base_url_and_force_update_method_channel.dart';

/// The interface that implementations of this plugin must extend.
abstract class DynamicBaseUrlAndForceUpdatePlatform extends PlatformInterface {
  /// Constructs a DynamicBaseUrlAndForceUpdatePlatform.
  DynamicBaseUrlAndForceUpdatePlatform() : super(token: _token);

  static final Object _token = Object();

  static DynamicBaseUrlAndForceUpdatePlatform _instance =
      MethodChannelDynamicBaseUrlAndForceUpdate();

  /// The default instance of [DynamicBaseUrlAndForceUpdatePlatform] to use.
  ///
  /// Defaults to [MethodChannelDynamicBaseUrlAndForceUpdate].
  static DynamicBaseUrlAndForceUpdatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DynamicBaseUrlAndForceUpdatePlatform] when
  /// they register themselves.
  static set instance(DynamicBaseUrlAndForceUpdatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Name and version of the platform the app runs on.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
