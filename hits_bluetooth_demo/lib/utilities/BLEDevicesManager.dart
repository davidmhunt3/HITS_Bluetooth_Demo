import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BLEDevice.dart';

class BLEDevicesManager {
  FlutterBlue _flutterBlue;

  //bluetooth state manager
  BluetoothState _bluetoothState = BluetoothState.unknown;
  StreamSubscription _bluetoothStateSubscription;

  //list of available devices

  //Search Result Settings
  bool _generateDebugDevices = false;
  bool _showOnlyHitsDevices = false;

  //initializer
  BLEDevicesManager() {
    _flutterBlue = FlutterBlue.instance;
    _bluetoothStateSubscription = _flutterBlue.state.listen((state) {
      print("Bluetooth State set to: ${state.toString()}");
      _bluetoothState = state;
    });
  }

  /*function to search for new devices for a duration of 4 seconds*/
  void Scan() {
    _flutterBlue.scan(timeout: Duration(seconds: 4));
  }
}
