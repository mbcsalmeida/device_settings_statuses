

import 'device_settings_statuses_platform_interface.dart';

class DeviceSettingsStatuses {
  Future<String?> getPlatformVersion() {
    return DeviceSettingsStatusesPlatform.instance.getPlatformVersion();
  }

  Future<String?> checkAirplaneMode() {
    return DeviceSettingsStatusesPlatform.instance.checkAirplaneMode();
  }

  Stream<String> onSettingsChanges(){
    return DeviceSettingsStatusesPlatform.instance.onSettingsChanges();
  }

  Stream<String> listenAirplaneMode() {
    return DeviceSettingsStatusesPlatform.instance.listenAirplaneMode();
  }

  Stream<String> listenInternetConnectivity(){
    return DeviceSettingsStatusesPlatform.instance.listenInternetConnectivity();
  }

  Stream<String> listenDNDMode(){
    return DeviceSettingsStatusesPlatform.instance.listenDNDMode();
  }
}
