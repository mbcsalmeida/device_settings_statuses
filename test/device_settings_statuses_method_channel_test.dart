import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_settings_statuses/src/device_settings_statuses_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceSettingsStatuses platform = MethodChannelDeviceSettingsStatuses();
  const MethodChannel channel = MethodChannel('device_settings_statuses');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
