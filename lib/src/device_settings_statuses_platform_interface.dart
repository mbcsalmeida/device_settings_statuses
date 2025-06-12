import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_settings_statuses_method_channel.dart';


abstract class DeviceSettingsStatusesPlatform extends PlatformInterface {

  DeviceSettingsStatusesPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceSettingsStatusesPlatform _instance = MethodChannelDeviceSettingsStatuses();
  static DeviceSettingsStatusesPlatform get instance => _instance;

  static set instance(DeviceSettingsStatusesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Stream<String> onSettingsChanges(){
    throw UnimplementedError('onSettingsChanges() has not been implemented.');
  }

  Future<String?> checkAirplaneMode() {
    throw UnimplementedError('checkAirplaneMode() has not been implemented.');
  }

  Stream<String> listenAirplaneMode() {
    throw UnimplementedError('listenAirplaneMode() has not been implemented.');
  }

  Stream<String> listenInternetConnectivity(){
    throw UnimplementedError('listenInternetConnectivity() has not been implemented.');
  }

  Stream<String> listenDNDMode(){
    throw UnimplementedError('listenDNDMode() has not been implemented.');
  }
}
