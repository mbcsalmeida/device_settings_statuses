import 'package:flutter_test/flutter_test.dart';
import 'package:device_settings_statuses/src/device_settings_statuses.dart';
import 'package:device_settings_statuses/device_settings_statuses_platform_interface.dart';
import 'package:device_settings_statuses/src/device_settings_statuses_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceSettingsStatusesPlatform
    with MockPlatformInterfaceMixin
    implements DeviceSettingsStatusesPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DeviceSettingsStatusesPlatform initialPlatform = DeviceSettingsStatusesPlatform.instance;

  test('$MethodChannelDeviceSettingsStatuses is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceSettingsStatuses>());
  });

  test('getPlatformVersion', () async {
    DeviceSettingsStatuses deviceSettingsStatusesPlugin = DeviceSettingsStatuses();
    MockDeviceSettingsStatusesPlatform fakePlatform = MockDeviceSettingsStatusesPlatform();
    DeviceSettingsStatusesPlatform.instance = fakePlatform;

    expect(await deviceSettingsStatusesPlugin.getPlatformVersion(), '42');
  });
}
