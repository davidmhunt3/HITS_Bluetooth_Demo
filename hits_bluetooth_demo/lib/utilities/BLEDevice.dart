import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BLEDevicesManager.dart';

class BLEDevice {
  final BluetoothDevice bluetoothDevice;
  final bool isDebug;

  BLEDevice({this.bluetoothDevice, this.isDebug = false});
}
