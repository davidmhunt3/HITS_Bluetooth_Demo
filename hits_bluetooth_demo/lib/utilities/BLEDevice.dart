import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BLEDevicesManager.dart';

class BLEDevice {
  final BluetoothDevice bluetoothDevice;
  final bool isDebug;
  String deviceName;
  String deviceState;

  BLEDevice({this.bluetoothDevice, this.isDebug = false}) {
    if (isDebug) {
      deviceName = 'HITS Simulated';
      deviceState = 'connected';
    } else {
      deviceName = bluetoothDevice.name;
      bluetoothDevice.state.listen((connectionState) {
        deviceState = connectionState.toString().split('.')[0];
      });
    }
  }
}
