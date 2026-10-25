import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDynamicBaseUrlAndForceUpdate platform =
      MethodChannelDynamicBaseUrlAndForceUpdate();

  // same channel name as the native code (Android, iOS, macOS, Linux, Windows)
  const MethodChannel channel =
      MethodChannel('dynamic_chnage_base_url_and_force_update');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
