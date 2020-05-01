import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/utilities/GyroLoAccSensor.dart';
import 'package:hits_bluetooth_demo/utilities/HiAccSensor.dart';
import 'DataProcessor.dart';
import 'BLEDevicesManager.dart';

class BLEDevice {
  //device variables
  final BluetoothDevice bluetoothDevice;
  final bool isDebug;
  String deviceName;

  //stream to manage the device connection state
  BluetoothDeviceState _deviceConnectionState;
  Timer _connectionTimer; //to try and automatically connect if disconnected
  StreamController _deviceConnectionStateController;
  Stream<String> get deviceConnectionStateStream =>
      _deviceConnectionStateController.stream;

  //stream to manage the device services
  bool _isScanningForServices = false;
  List<BluetoothService> _services;

  //stream to manage the data from the Gyro/LoAcc(low-g)
  BluetoothService _hitsSensorService;
  GyroLoAccSensor gyroLoAccSensor;
  HiAccSensor hiAccSensor;

  //Data Processor
  DataProcessor dataProcessor;

  BLEDevice({this.bluetoothDevice, this.isDebug = false}) {
    _deviceConnectionStateController = StreamController<String>();
    if (isDebug) {
      deviceName = 'HITS Simulated';
      _deviceConnectionState = BluetoothDeviceState.disconnected;
      _deviceConnectionStateController.sink.add('disconnected');
      dataProcessor = DataProcessor(
          gyroLoAccSensor: null, hiAccSensor: null, isDebug: true);
    } else {
      //get the device name
      deviceName = (bluetoothDevice.name.length > 0)
          ? bluetoothDevice.name
          : bluetoothDevice.id.id;

      //setup the connection status stream
      initConnectionStateStream();

      //setup the stream to check if it is scanning for services
      initDiscoveringServicesSteam();

      //setup the services stream
      initHITSSensorServiceStream();

      //initialize an instance of GyroLoAccSensor
      gyroLoAccSensor = GyroLoAccSensor();

      //initialize an instance of HiAccSensor
      hiAccSensor = HiAccSensor();

      //initialize an instance of Dataprocessor
      dataProcessor = DataProcessor(
          gyroLoAccSensor: gyroLoAccSensor,
          hiAccSensor: hiAccSensor,
          isDebug: false);
    }
    //automatically try to connect if its a HITS sensor
    connectIfHits();
  }

  void connect() {
    if (isDebug) {
      print('Device: Debug Connected');
    } else {
      bluetoothDevice.connect();
    }
  }

  void connectIfHits() {
    if (isDebug) {
      print('Device: Debug Connected');
      _deviceConnectionStateController.sink.add('connected');
    } else if (deviceName == kHitsDeviceName) {
      if (_deviceConnectionState != BluetoothDeviceState.connected)
        bluetoothDevice.connect();
    }
  }

  void initDiscoveringServicesSteam() {
    bluetoothDevice.isDiscoveringServices.listen((scanningStatus) {
      _isScanningForServices = scanningStatus;
      print(
          "BLEDevice/serviceScanning: scanning status = ${scanningStatus.toString()}");
    });
  }

  void initConnectionStateStream() {
    bluetoothDevice.state.listen((connectionState) {
      print("BLEDevice/connection: state set to $connectionState");
      if (_deviceConnectionState != connectionState) {
        if (connectionState == BluetoothDeviceState.connected) {
          if (_connectionTimer != null) {
            _connectionTimer.cancel();
          }
          bluetoothDevice.discoverServices();
        }
        if (connectionState == BluetoothDeviceState.disconnected &&
            deviceName == kHitsDeviceName) {
          _connectionTimer = Timer(kConnectionTimer, connectIfHits);
        }
      }
      _deviceConnectionState = connectionState;
      _deviceConnectionStateController.sink
          .add(connectionState.toString().split('.')[1]);
    }, onDone: () {
      _deviceConnectionStateController.close();
      print('BLEDevice/connection: Connection Closed');
    }, onError: (error) {
      _deviceConnectionStateController.close();
      print(
          'BLEDevice/connection: Error ${error.toString()} caused connection close');
    });
  }

  void initHITSSensorServiceStream() {
    bluetoothDevice.services.listen((listOfServices) {
      if (_services == null) {
        _services = [];
      }
      if (listOfServices != _services) {
        _services.addAll(listOfServices.where((service) {
          return _services.contains(service) ? false : true;
        }).toList());
        List<Guid> listOfIDs =
            _services.map((service) => service.uuid).toList();
        for (int i = 0; i < _services.length; i++) {
          if (listOfIDs.contains(kHITSSensorServiceUUID)) {
            print("BLEDevice/services: found HITSSensor service");
            _hitsSensorService =
                listOfServices[listOfIDs.indexOf(kHITSSensorServiceUUID)];
            initHITSSensorCharacteristics(
                hitsSensorService: _hitsSensorService);
          } else {
            print(
                "BLEDevice/services: unknown service: ${_services[i].uuid.toString()}");
          }
        }
      }
    });
  }

  void initHITSSensorCharacteristics(
      {@required BluetoothService hitsSensorService}) {
    List<BluetoothCharacteristic> listOfCharacteristics =
        hitsSensorService.characteristics;
    for (int i = 0; i < listOfCharacteristics.length; i++) {
      if (listOfCharacteristics[i].uuid == kGyroLoAccCharacteristicUUID) {
        print("BLEDevice/characteristics: found GyroLoAcc characteristic");
        gyroLoAccSensor.setBLECharacteristic(
            characteristic: listOfCharacteristics[i]);
      } else if (listOfCharacteristics[i].uuid == kHiAccCharacteristicUUID) {
        print("BLEDevice/characteristics: found HiAcc characteristic");
        hiAccSensor.setBLECharacteristic(
            characteristic: listOfCharacteristics[i]);
      } else {
        print(
            "BLEDevice/characteristics: unknown characteristic: ${listOfCharacteristics[i].uuid}");
      }
    }
  }
}
