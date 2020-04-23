import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BLEDevice.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/DeviceCard.dart';

class BLEDevicesManager {
  FlutterBlue _flutterBlue;

  //bluetooth state stream
  BluetoothState _bluetoothState = BluetoothState.unknown;
  StreamSubscription _bluetoothStateSubscription;

  //bluetooth scanning state stream
  bool _bluetoothScanningState;
  StreamSubscription _bluetoothScanningStateSubscription;

  //list of  BLEdevices
  StreamSubscription _BLEScanSubscription;
  List<BLEDevice> BLEDevices;

  //Stream of scan results
  StreamController _scanResults;
  Stream<List<BLEDevice>> get scanResultStream => _scanResults.stream;

  //Search Result Settings
  bool _generateSimulatedDevices = true;
  bool _showOnlyHitsDevices = false;

  //initializer
  BLEDevicesManager() {
    _flutterBlue = FlutterBlue.instance;

    //initialize the bluetooth state stream
    _bluetoothStateSubscription = _flutterBlue.state.listen((state) {
      print("Bluetooth State set to: ${state.toString()}");
      _bluetoothState = state;
    });

    //initialize the bluetooth scanning state stream
    _bluetoothScanningStateSubscription =
        _flutterBlue.isScanning.listen((scanState) {
      print("Scanning State set to: ${scanState.toString()}");
      _bluetoothScanningState = scanState;
    });

    _scanResults = StreamController<List<BLEDevice>>();
    //_scanResults.close();

    //process the scan result stream, update the BLEDevices List
    _flutterBlue.scanResults.listen((results) {
      BLEDevices = results
          .where((event) {
            if (!_showOnlyHitsDevices) {
              return true;
            } else {
              //show only HITS devices
              return true;
            }
          })
          .map((result) => BLEDevice(bluetoothDevice: result.device))
          .toList();
      BLEDevices.addAll(_createSimulatedDevices());
      _scanResults.sink.add(BLEDevices);
      print("Scan: result list length: ${BLEDevices.length}");
    }, onDone: () {
      print('Scan Complete');
      _scanResults.close();
    }, onError: (error) {
      print('Scan Error: ${error.toString()}');
      _scanResults.close();
    });
  }

  /*function to search for new devices for a duration of 4 seconds*/
  void scan({@required Duration timeout}) {
    print('Scan called');
    if (_bluetoothState == BluetoothState.on &&
        _bluetoothScanningState != true) {
      //start a scan and create new scanResult Stream
      _flutterBlue.startScan(timeout: timeout);
      //_scanResults = StreamController<List<BLEDevice>>();

    } else {
      print('Scan: generating simulated values');
      //_scanResults = StreamController<List<BLEDevice>>();
      _scanResults.sink.add(_createSimulatedDevices());
      //_scanResults.close();
    }
  }

  /*function to create simulated devices*/
  List<BLEDevice> _createSimulatedDevices() {
    if (_generateSimulatedDevices) {
      return [
        BLEDevice(bluetoothDevice: null, isDebug: true),
        BLEDevice(bluetoothDevice: null, isDebug: true)
      ];
    } else {
      return [];
    }
  }
}
