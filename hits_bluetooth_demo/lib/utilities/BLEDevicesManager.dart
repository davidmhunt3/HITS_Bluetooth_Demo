import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hits_bluetooth_demo/constants.dart';
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
  List<ScanResult> previousScanResults;
  List<ScanResult> currentScanresults;
  List<BLEDevice> BLEDevices;

  //Stream of scan results
  StreamController _scanResults;
  Stream<List<BLEDevice>> get scanResultStream => _scanResults.stream;

  //Search Result Settings
  bool _generateSimulatedDevices = true;
  bool _generatedSimulatedDevices = false;
  bool _showOnlyHitsDevices = true;

  //initializer
  BLEDevicesManager() {
    _flutterBlue = FlutterBlue.instance;

    //initialize the bluetooth state stream
    _bluetoothStateSubscription = _flutterBlue.state.listen((state) {
      print("Bluetooth State set to: ${state.toString()}");
      if (_bluetoothState != state && state == BluetoothState.on) {
        print("BLEDevicesManager/bluetoothState: commencing scan");
        _bluetoothState = state;
        scan(timeout: Duration(seconds: 4));
      } else {
        _bluetoothState = state;
      }
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
    previousScanResults = [];
    BLEDevices = [];
    _flutterBlue.scanResults.listen((results) {
      currentScanresults = results.where((result) {
        if (!_showOnlyHitsDevices) {
          return true;
        } else {
          if (result.device.name == kHitsDeviceName) {
            //check if HITS
            if (previousScanResults.contains(result)) {
              //if already seen
              return false;
            } else {
              //its a new device
              print("BLEDevicesManager/scanning: found HITS device");
              previousScanResults.add(result);
              return true;
            }
          } else {
            //if not HITS
            return false;
          }
        }
      }).toList();
      if (currentScanresults.length > 0) {
        BLEDevices.addAll(currentScanresults
            .map((result) => BLEDevice(bluetoothDevice: result.device)));
        print(
            "BLEDevicesManager/scanning: list contains: ${BLEDevices.length} HITS device");
      }
      BLEDevices.addAll(_createSimulatedDevices());
      _scanResults.sink.add(BLEDevices);
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
    if (_bluetoothState == BluetoothState.on &&
        _bluetoothScanningState != true) {
      print('Scan: running a scan');
      //start a scan and create new scanResult Stream
      _flutterBlue.startScan(timeout: timeout);
      //_scanResults = StreamController<List<BLEDevice>>();

    } else if (_generateSimulatedDevices == true) {
      print('Scan: generating simulated values');
      //_scanResults = StreamController<List<BLEDevice>>();
      BLEDevices.addAll(_createSimulatedDevices());
      _scanResults.sink.add(BLEDevices);
      //_scanResults.close();
    } else {
      print("Scan called, but couldn't scan");
    }
  }

  /*function to create simulated devices*/
  List<BLEDevice> _createSimulatedDevices() {
    if (_generateSimulatedDevices && !_generatedSimulatedDevices) {
      _generatedSimulatedDevices = true;
      print("BLEDevicesManager/simulatedDevices: generating simulated devices");
      return [
        BLEDevice(bluetoothDevice: null, isDebug: true),
        BLEDevice(bluetoothDevice: null, isDebug: true)
      ];
    } else {
      return [];
    }
  }
}
