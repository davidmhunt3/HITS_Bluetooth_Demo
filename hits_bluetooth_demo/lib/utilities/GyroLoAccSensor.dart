import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class GyroLoAccSensor {
  BluetoothCharacteristic _bleCharacteristic;

  //saving the characteristic value
  //List<int> characteristicValue;
  //the ByteBuffer to be used to convert the raw sensor data to a float
  ByteData _byteData;

  //variables to store the current x,y,and z acceleration values
  double _curxAcc;
  double _curyAcc;
  double _curzAcc;
  double _curxGyro;
  double _curyGyro;
  double _curzGyro;

  //output stream of sensor data
  List<double> _sensorValues;
  StreamController _sensorValuesController;
  Stream<List<double>> get sensorValuesStream => _sensorValuesController.stream;

  //variable to keep track of the refresh rate of the sensor
  Stopwatch _stopwatch;

  GyroLoAccSensor() {
    print("GyroLoAccSensor: Initializing Sensor");
    //initialize the ByteBuffer
    _byteData = ByteData(4);

    //initialize the output stream of values
    _sensorValues = List.filled(6, 0.0);
    _sensorValuesController = StreamController<List<double>>();
    _sensorValuesController.sink.add(_sensorValues);

    //initialize the timing to track the refresh rate
    _stopwatch = Stopwatch();
    _stopwatch.start();
  }

  void setBLECharacteristic(
      {@required BluetoothCharacteristic characteristic}) {
    print("GyroLoAccSensor/setCharacteristic: New Characteristic Set");
    _bleCharacteristic = characteristic;

    //initialize the stream
    _bleCharacteristic.value.listen((value) {
      _curxAcc = _byteArrayToFloat(value, 0);
      _curyAcc = _byteArrayToFloat(value, 4);
      _curzAcc = _byteArrayToFloat(value, 8);
      _curxGyro = _byteArrayToFloat(value, 12);
      _curyGyro = _byteArrayToFloat(value, 16);
      _curzGyro = _byteArrayToFloat(value, 20);
      //printCurrentValues();
      _getRefreshPeriod();
      _updateSensorValuesList();
      _sensorValuesController.sink.add(_sensorValues);
    });

    //set the characteristic to notify when new values are available
    _bleCharacteristic.setNotifyValue(true);
  }

  double _byteArrayToFloat(List values, int index) {
    //takes in a byte array of 4 values and converts it to a floating point value
    int i = index;
    for (i = index; i < index + 4; i++) {
      _byteData.setInt8(i - index, values[i]);
    }
    return _byteData.getFloat32(0, Endian.little);
  }

  void _updateSensorValuesList() {
    _sensorValues[0] = _curxAcc;
    _sensorValues[1] = _curyAcc;
    _sensorValues[2] = _curzAcc;
    _sensorValues[3] = _curxGyro;
    _sensorValues[4] = _curyGyro;
    _sensorValues[5] = _curzGyro;
  }

  void _printCurrentValues() {
    print("GyroLoAccSensor/AccValues: "
        "x-axis: ${_curxAcc.toStringAsFixed(2)} "
        "y-axis: ${_curyAcc.toStringAsFixed(2)} "
        "z-axis: ${_curzAcc.toStringAsFixed(2)} /n/"
        "GyroValues: "
        "x-axis: ${_curxGyro.toStringAsFixed(2)} "
        "y-axis: ${_curyGyro.toStringAsFixed(2)} "
        "z-axis: ${_curzGyro.toStringAsFixed(2)}");
    return;
  }

  void _getRefreshPeriod() {
    _stopwatch.stop();
    //print("GyroLoAccSensor/RefreshPeriod: ${_stopwatch.elapsedMilliseconds}ms");
    _stopwatch.reset();
    _stopwatch.start();
  }
}
