import 'dart:async';

import 'package:flutter/material.dart';
import 'GyroLoAccSensor.dart';

class DataProcessor {
  //impliment functionality to simulate a data processor
  final bool isDebug;

  //sensor data objects
  GyroLoAccSensor gyroLoAccSensor;

  //Data Processor Variables
  List<double> _xAccBuffer;
  List<double> _yAccBuffer;
  List<double> _zAccBuffer;
  List<double> _xGyroBuffer;
  List<double> _yGyroBuffer;
  List<double> _zGyroBuffer;
  int _dataValueIndex;
  int _gyroLoAccBufferTic;
  int _gyroLoAccBufferWaitTicks = 20;

  //stream controllers for Data Processor Variables
  StreamController _accBufferController;
  StreamController _gyroBufferController;

  //streams for Data Processor Variables
  Stream<List<List<double>>> get accBufferStream => _accBufferController.stream;
  Stream<List<List<double>>> get gyroBufferStream =>
      _gyroBufferController.stream;

  DataProcessor({@required this.gyroLoAccSensor, @required this.isDebug}) {
    print("DataProcessor: initializing data processor");
    _dataValueIndex = 0;
    _gyroLoAccBufferTic = _gyroLoAccBufferWaitTicks;

    //initialize Data Processor Variables
    _xAccBuffer = List.filled(1000, 0.0);
    _yAccBuffer = List.filled(1000, 0.0);
    _zAccBuffer = List.filled(1000, 0.0);
    _xGyroBuffer = List.filled(1000, 0.0);
    _yGyroBuffer = List.filled(1000, 0.0);
    _zGyroBuffer = List.filled(1000, 0.0);

    //initialize stream controllers for Data Processor Variables
    _accBufferController = StreamController<List<List<double>>>();
    _gyroBufferController = StreamController<List<List<double>>>();

    //set initial values Data Processor Variable Streams
    _accBufferController.sink.add([_xAccBuffer, _yAccBuffer, _zAccBuffer]);
    _gyroBufferController.sink.add([_xGyroBuffer, _yGyroBuffer, _zGyroBuffer]);

    //initialize stream subscribers to get data from the sensors
    if (!isDebug) {
      initGyroLoAccSensorDataBufferStream();
    }
  }

  void initGyroLoAccSensorDataBufferStream() {
    gyroLoAccSensor.sensorValuesStream.listen((currentData) {
      updateDataBuffers(currentData);
      clockGyroLoAccBufferController();
//      print(
//          "DataProcessor/BufferController: x[0] = ${_xAccBuffer[0]} i = $_dataValueIndex");
    });
  }

  void clockGyroLoAccBufferController() {
    if (--_gyroLoAccBufferTic <= 0) {
      _accBufferController.add([_xAccBuffer, _yAccBuffer, _zAccBuffer]);
      _gyroBufferController.sink
          .add([_xGyroBuffer, _yGyroBuffer, _zGyroBuffer]);
      _gyroLoAccBufferTic = _gyroLoAccBufferWaitTicks;
    }
  }

  void updateDataBuffers(List<double> currentData) {
    _xAccBuffer[_dataValueIndex] = currentData[0];
    _yAccBuffer[_dataValueIndex] = currentData[1];
    _zAccBuffer[_dataValueIndex] = currentData[2];
    _xGyroBuffer[_dataValueIndex] = currentData[3];
    _yGyroBuffer[_dataValueIndex] = currentData[4];
    _zGyroBuffer[_dataValueIndex] = currentData[5];

    if (_dataValueIndex >= 1000 - 1) {
      _dataValueIndex = 0;
    } else {
      _dataValueIndex++;
    }
  }
}
