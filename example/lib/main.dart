import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_settings_statuses/device_settings_statuses.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSettingsStatusesPlugin = DeviceSettingsStatuses();
  String status = "";


  @override
  void initState() {
    super.initState();
    initDevicesStatusListener();
  }

  void initDevicesStatusListener(){
    _deviceSettingsStatusesPlugin.onSettingsChanges().listen((value){

      switch (value) {
        case DeviceSettingsStatusesTypes.AIRPLANE_MODE_ON:
          setState(() {
            status = "Airplane Mode is On";
          });
          break;
        case DeviceSettingsStatusesTypes.INTERNET_DISCONNECTED:
          setState(() {
            status = "Internet is disconnected";
          });
          break;
        case DeviceSettingsStatusesTypes.DND_MODE_ON:
          setState(() {
            status = "Do Not Disturb Mode is On";
          });
          break;
        case DeviceSettingsStatusesTypes.DND_MODE_OFF:
          setState(() {
            status = "Do Not Disturb Mode is Off";
          });
          break;
        case DeviceSettingsStatusesTypes.INTERNET_CONNECTED:
          setState(() {
            status = "Internet is connected";
          });
          break;
        case DeviceSettingsStatusesTypes.AIRPLANE_MODE_OFF:
          setState(() {
            status = "Airplane Mode is Off";
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Statuses Example App'),
        ),
        body: Center(
          child: Text(status),
        ),
      ),
    );
  }
}
