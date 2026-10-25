import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';
import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update_method_channel.dart';
import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDynamicBaseUrlAndForceUpdatePlatform
    with MockPlatformInterfaceMixin
    implements DynamicBaseUrlAndForceUpdatePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DynamicBaseUrlAndForceUpdatePlatform initialPlatform =
      DynamicBaseUrlAndForceUpdatePlatform.instance;

  test('$MethodChannelDynamicBaseUrlAndForceUpdate is the default instance',
      () {
    expect(initialPlatform, isA<MethodChannelDynamicBaseUrlAndForceUpdate>());
  });

  test('getPlatformVersion', () async {
    DynamicBaseUrlAndForceUpdate plugin = DynamicBaseUrlAndForceUpdate();
    MockDynamicBaseUrlAndForceUpdatePlatform fakePlatform =
        MockDynamicBaseUrlAndForceUpdatePlatform();
    DynamicBaseUrlAndForceUpdatePlatform.instance = fakePlatform;

    expect(await plugin.getPlatformVersion(), '42');
  });
}
