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
      deviceName = (bluetoothDevice.name.length > 0)
          ? bluetoothDevice.name
          : bluetoothDevice.id.id;
      //print("BLEDevice: device created");
      bluetoothDevice.state.listen((connectionState) {
        deviceState = connectionState.toString().split('.')[1];
        //print("BLEdevice: device state set to: $deviceState");
      });
    }
  }

  void connect() {
    if (isDebug) {
      print('Device: Debug Connected');
    } else {
      bluetoothDevice.connect();
    }
  }
}
