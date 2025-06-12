import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_settings_statuses_platform_interface.dart';


/// An implementation of [DeviceSettingsStatusesPlatform] that uses method channels.
class MethodChannelDeviceSettingsStatuses extends DeviceSettingsStatusesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_settings_statuses');

  /// The event channel used to receive stream data from the native platform.
  final deviceSettingsEventChannel = const EventChannel('pt.mbcsalmeida/device_settings_statuses_stream');
  final airplaneEventChannel = const EventChannel('device_settings_statuses_airplane_stream');
  final networkEventChannel = const EventChannel('device_settings_statuses_network_stream');
  final dndEventChannel = const EventChannel("device_settings_statuses_dnd_stream");


  @override
  Future<String?> getPlatformVersion() async {
    final version =
    await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<String> onSettingsChanges(){
    return deviceSettingsEventChannel.receiveBroadcastStream().map((event) => event.toString());
  }

  @override
  Future<String?> checkAirplaneMode() async {
    final mode = await methodChannel.invokeMethod<String>('checkAirplaneMode');
    return mode;
  }

  @override
  Stream<String> listenAirplaneMode() {
    return airplaneEventChannel
        .receiveBroadcastStream()
        .map((event) => event as String);
  }

  @override
  Stream<String> listenInternetConnectivity() {
    return networkEventChannel.receiveBroadcastStream().map((event) => event.toString());
  }

  @override
  Stream<String> listenDNDMode() {
    return dndEventChannel
        .receiveBroadcastStream()
        .map((event) => event as String);
  }
}
