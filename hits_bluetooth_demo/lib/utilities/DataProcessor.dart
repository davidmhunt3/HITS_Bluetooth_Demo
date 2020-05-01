import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/utilities/HiAccSensor.dart';
import 'GyroLoAccSensor.dart';
import 'hitDetector.dart';

class DataProcessor {
  //impliment functionality to simulate a data processor
  final bool isDebug;

  //sensor data objects
  GyroLoAccSensor gyroLoAccSensor;
  HiAccSensor hiAccSensor;

/*  //Current Sensor Readings
  double _xHiAcc;
  double _yHiAcc;
  double _zHiAcc;
  double _xIMUAcc;
  double _yIMUAcc;
  double _zIMUAcc;
  double _xIMUGyro;
  double _yIMUGyro;
  double _zIMUGyro;*/ //current sensor readings

  //Safety Metrics
  int hits;
  int hardHits;
  double highG;
  HitDetector hitDetector;
  //HIT State Machine Variables

  //Data Processor Buffers
  List<double> _xLoAccBuffer;
  List<double> _yLoAccBuffer;
  List<double> _zLoAccBuffer;
  List<double> _xHiAccBuffer;
  List<double> _yHiAccBuffer;
  List<double> _zHiAccBuffer;
  List<double> _xGyroBuffer;
  List<double> _yGyroBuffer;
  List<double> _zGyroBuffer;

  //support variables for the data processor
  int _currentGyroLoAccBufferIndex;
  int _currentHiAccBufferIndex;
  int _gyroLoAccBufferTic;
  int _gyroLoAccBufferWaitTicks = 20;
  int _hiAccBufferTic;
  int _hiAccBufferWaitTicks = 20;

  //stream controllers
  StreamController _loAccBufferController;
  StreamController _gyroBufferController;
  StreamController _hiAccBufferController;
  StreamController _safetyController;

  //streams for Data Processor Variables
  Stream<List<List<double>>> get loAccBufferStream =>
      _loAccBufferController.stream;
  Stream<List<List<double>>> get hiAccBufferStream =>
      _hiAccBufferController.stream;
  Stream<List<List<double>>> get gyroBufferStream =>
      _gyroBufferController.stream;
  Stream<List> get safetyStream => _safetyController.stream;

  DataProcessor(
      {@required this.gyroLoAccSensor,
      @required this.hiAccSensor,
      @required this.isDebug}) {
    print("DataProcessor: initializing data processor");

    initDataProcessorVariables();

    //setup the stream controllers and their corresponding streams
    initDataProcessorStreams();

    //initialize stream subscribers to get data from the sensors
    if (!isDebug) {
      initGyroLoAccSensorDataBufferStream();
      initHiAccSensorDataBufferStream();
    }
  }

  void initDataProcessorVariables() {
    _currentGyroLoAccBufferIndex = 0;
    _currentHiAccBufferIndex = 0;
    _gyroLoAccBufferTic = _gyroLoAccBufferWaitTicks;
    _hiAccBufferTic = _hiAccBufferWaitTicks;

    //Initialize Safety Metrics
    hits = 0;
    hardHits = 0;
    highG = 0.0;
    hitDetector = HitDetector();
    hitDetector.resetHighG();

    //initialize Data Processor Variables
    _xLoAccBuffer = List.filled(1000, 0.0);
    _yLoAccBuffer = List.filled(1000, 0.0);
    _zLoAccBuffer = List.filled(1000, 0.0);
    _xHiAccBuffer = List.filled(1000, 0.0);
    _yHiAccBuffer = List.filled(1000, 0.0);
    _zHiAccBuffer = List.filled(1000, 0.0);
    _xGyroBuffer = List.filled(1000, 0.0);
    _yGyroBuffer = List.filled(1000, 0.0);
    _zGyroBuffer = List.filled(1000, 0.0);
  }

  void initDataProcessorStreams() {
    //initialize stream controllers for Data Processor Variables
    _loAccBufferController = StreamController<List<List<double>>>();
    _gyroBufferController = StreamController<List<List<double>>>();
    _hiAccBufferController = StreamController<List<List<double>>>();
    _safetyController = StreamController<List>();

    //set initial values Data Processor Variable Streams
    _loAccBufferController.sink
        .add([_xLoAccBuffer, _yLoAccBuffer, _zLoAccBuffer]);
    _gyroBufferController.sink.add([_xGyroBuffer, _yGyroBuffer, _zGyroBuffer]);
    _hiAccBufferController.sink
        .add([_xHiAccBuffer, _yHiAccBuffer, _zHiAccBuffer]);
    _safetyController.sink.add([hits, hardHits, highG]);
  }

  void initGyroLoAccSensorDataBufferStream() {
    gyroLoAccSensor.sensorValuesStream.listen((currentData) {
      updateGyroLoAccDataBuffers(currentData);
      clockGyroLoAccBufferController();
      updateSafetyMetrics(currentData);
//      print(
//          "DataProcessor/BufferController: x[0] = ${_xAccBuffer[0]} i = $_dataValueIndex");
    });
  }

  void initHiAccSensorDataBufferStream() {
    hiAccSensor.sensorValuesStream.listen((currentData) {
      updateHiAccDataBuffers(currentData);
      clockHiAccBufferController();

//      print(
//          "DataProcessor/BufferController: x[0] = ${_xAccBuffer[0]} i = $_dataValueIndex");
    });
  }

  void updateSafetyMetrics(List<double> currentData) {
    hitDetector.clockDetector(currentData);
    if (hitDetector.hitDetected()) {
      hits = hits + 1;
      hitDetector.clearHitDetected();
      if (hitDetector.hardHitDetected()) {
        hardHits = hardHits + 1;
        hitDetector.clearHardHitDetected();
      }
      if (hitDetector.newHighG()) {
        highG = hitDetector.getHighG();
        hitDetector.clearNewHighG();
      }
      _safetyController.sink.add([hits, hardHits, highG]);
    } //if a hard hit develops later
    else if (hitDetector.hardHitDetected()) {
      hardHits = hardHits + 1;
      hitDetector.clearHardHitDetected();
      if (hitDetector.newHighG()) {
        highG = hitDetector.getHighG();
        hitDetector.clearNewHighG();
      }
      _safetyController.sink.add([hits, hardHits, highG]);
    }
  }

  void clockGyroLoAccBufferController() {
    if (--_gyroLoAccBufferTic <= 0) {
      _loAccBufferController.sink
          .add([_xLoAccBuffer, _yLoAccBuffer, _zLoAccBuffer]);
      _gyroBufferController.sink
          .add([_xGyroBuffer, _yGyroBuffer, _zGyroBuffer]);
      _gyroLoAccBufferTic = _gyroLoAccBufferWaitTicks;
    }
  }

  void clockHiAccBufferController() {
    if (--_hiAccBufferTic <= 0) {
      _hiAccBufferController.sink
          .add([_xHiAccBuffer, _yHiAccBuffer, _zHiAccBuffer]);
      _hiAccBufferTic = _hiAccBufferWaitTicks;
    }
  }

  void updateGyroLoAccDataBuffers(List<double> currentData) {
    _xLoAccBuffer[_currentGyroLoAccBufferIndex] = currentData[0];
    _yLoAccBuffer[_currentGyroLoAccBufferIndex] = currentData[1];
    _zLoAccBuffer[_currentGyroLoAccBufferIndex] = currentData[2];
    _xGyroBuffer[_currentGyroLoAccBufferIndex] = currentData[3];
    _yGyroBuffer[_currentGyroLoAccBufferIndex] = currentData[4];
    _zGyroBuffer[_currentGyroLoAccBufferIndex] = currentData[5];

    if (_currentGyroLoAccBufferIndex >= 1000 - 1) {
      _currentGyroLoAccBufferIndex = 0;
    } else {
      _currentGyroLoAccBufferIndex++;
    }
  }

  void updateHiAccDataBuffers(List<double> currentData) {
    _xHiAccBuffer[_currentHiAccBufferIndex] = currentData[0];
    _yHiAccBuffer[_currentHiAccBufferIndex] = currentData[1];
    _zHiAccBuffer[_currentHiAccBufferIndex] = currentData[2];

    if (_currentHiAccBufferIndex >= 1000 - 1) {
      _currentHiAccBufferIndex = 0;
    } else {
      _currentHiAccBufferIndex++;
    }
  }

  void resetVariables() {
    _currentGyroLoAccBufferIndex = 0;
    _currentHiAccBufferIndex = 0;
    _gyroLoAccBufferTic = _gyroLoAccBufferWaitTicks;
    _hiAccBufferTic = _hiAccBufferWaitTicks;

    //Initialize Safety Metrics
    hits = 0;
    hardHits = 0;
    highG = 0.0;
    hitDetector.resetHighG();

    //clear the buffers and reset them
    _xLoAccBuffer = List.filled(1000, 0.0);
    _yLoAccBuffer = List.filled(1000, 0.0);
    _zLoAccBuffer = List.filled(1000, 0.0);
    _xHiAccBuffer = List.filled(1000, 0.0);
    _yHiAccBuffer = List.filled(1000, 0.0);
    _zHiAccBuffer = List.filled(1000, 0.0);
    _xGyroBuffer = List.filled(1000, 0.0);
    _yGyroBuffer = List.filled(1000, 0.0);
    _zGyroBuffer = List.filled(1000, 0.0);
  }

  void resetStreams() {
    _loAccBufferController.close();
    _gyroBufferController.close();
    _hiAccBufferController.close();
    _safetyController.close();

    _loAccBufferController = StreamController<List<List<double>>>();
    _gyroBufferController = StreamController<List<List<double>>>();
    _hiAccBufferController = StreamController<List<List<double>>>();
    _safetyController = StreamController<List>();

    //set initial values Data Processor Variable Streams
    _loAccBufferController.sink
        .add([_xLoAccBuffer, _yLoAccBuffer, _zLoAccBuffer]);
    _gyroBufferController.sink.add([_xGyroBuffer, _yGyroBuffer, _zGyroBuffer]);
    _hiAccBufferController.sink
        .add([_xHiAccBuffer, _yHiAccBuffer, _zHiAccBuffer]);
    _safetyController.sink.add([hits, hardHits, highG]);
  }
}
