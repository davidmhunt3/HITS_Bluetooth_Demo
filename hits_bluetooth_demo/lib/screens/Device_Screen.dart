import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ValueCard.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ChartCard.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/DataCard.dart';
import 'dart:math';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  SeriesData xAcc = SeriesData(
      title: 'X-Axis',
      series: [1, 1, 1, 1, 1, 1, .7, .2, .7, 1, 1],
      color: Colors.red);
  SeriesData yAcc = SeriesData(
      title: 'Y-Axis',
      series: [0, 0, 0, 0, 0, 0, 2, 7, .1, 0, 0],
      color: Colors.green);
  SeriesData zAcc = SeriesData(
      title: 'Z-Axis',
      series: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      color: Colors.lightBlue);
  SeriesData xGyro = SeriesData(
      title: 'X-Axis',
      series: [10, 10, 10, 9, 15, 8, 5, 4, 3, 1, 1],
      color: Colors.red);
  SeriesData yGyro = SeriesData(
      title: 'Y-Axis',
      series: [0, 0, 0, 0, 5, 9, 15, 13, 10, 10, 10],
      color: Colors.yellow);
  SeriesData zGyro = SeriesData(
      title: 'Z-Axis',
      series: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      color: Colors.lightBlue);
  double pitch = 40.0;
  double roll = 10.5;
  double yaw = 90.0;
  int hits = 5;
  double speed = 10.0;
  double distance = 1;

  void randomizeValues() {
    Random randomGenerator = Random.secure();
    List<SeriesData> listsToRandomize = [xAcc, yAcc, zAcc];
    for (int i = 0; i < listsToRandomize.length; i++) {
      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
        listsToRandomize[i].series[j] = randomGenerator.nextInt(10).toDouble();
      }
    }
    listsToRandomize = [xGyro, yGyro, zGyro];
    for (int i = 0; i < listsToRandomize.length; i++) {
      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
        listsToRandomize[i].series[j] = randomGenerator.nextInt(15).toDouble();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HITS Sensor'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            print('Re-Center Pressed');
            setState(() {
              randomizeValues();
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: kBottomAppBarPadding),
            constraints: BoxConstraints.expand(height: kBottomAppBarHeight),
            child: Center(
              child: Text(
                'Re-Center',
                style: kBottomAppBarTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(double.infinity, kDeviceCardMargin / 2),
            ),
            ChartCard(
              title: "Accelerometer G's",
              chartData: [xAcc, yAcc, zAcc],
            ),
            DataCard(title: 'Performance', children: [
              ValueCard(value: hits.toString(), label: 'Hits'),
              ValueCard(value: speed.toStringAsFixed(1), label: 'speed'),
              ValueCard(value: distance.toStringAsFixed(1), label: 'Distance')
            ]),
            ChartCard(
                title: 'Gyroscope Data', chartData: [xGyro, yGyro, zGyro]),
            DataCard(
              title: 'Orientation',
              children: <Widget>[
                ValueCard(
                  value: '${pitch.toStringAsFixed(1)}°',
                  label: 'Pitch',
                ),
                ValueCard(
                  value: '${roll.toStringAsFixed(1)}°',
                  label: 'Roll',
                ),
                ValueCard(
                  value: '${yaw.toStringAsFixed(1)}°',
                  label: 'Yaw',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
