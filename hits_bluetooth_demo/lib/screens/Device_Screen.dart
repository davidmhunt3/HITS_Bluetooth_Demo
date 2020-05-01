import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ValueCard.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ChartCard.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/DataCard.dart';
import 'package:hits_bluetooth_demo/utilities/BLEDevice.dart';
import 'package:hits_bluetooth_demo/utilities/DataProcessor.dart';

class DeviceScreen extends StatefulWidget {
  final BLEDevice bleDevice;

  DeviceScreen({@required this.bleDevice});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  //the device and corresponding data processor
  BLEDevice bleDevice;
  DataProcessor dataProcessor;

  //stream variables that will produce the real-time data
  Stream<List<List<double>>> loAccBufferStream;
  Stream<List<List<double>>> gyroBufferStream;
  Stream<List<List<double>>> hiAccBufferStream;
  Stream<List> safetyStream;

  //Series Data Objects for plotting the acceleration and gyroscope
  SeriesData xAcc;
  SeriesData yAcc;
  SeriesData zAcc;
  SeriesData xGyro;
  SeriesData yGyro;
  SeriesData zGyro;
  List safetyMetrics;

  double pitch = 40.0;
  double roll = 10.5;
  double yaw = 90.0;
  int hits = 5;
  int hardHits = 10;
  double highG = 1;

  void randomizeValues() {
    print('Device_Screen: randomizeValues function disabled');
//    Random randomGenerator = Random.secure();
//    List<SeriesData> listsToRandomize = [xAcc, yAcc, zAcc];
//    for (int i = 0; i < listsToRandomize.length; i++) {
//      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
//        listsToRandomize[i].series[j] = randomGenerator.nextInt(10).toDouble();
//      }
//    }
//    listsToRandomize = [xGyro, yGyro, zGyro];
//    for (int i = 0; i < listsToRandomize.length; i++) {
//      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
//        listsToRandomize[i].series[j] = randomGenerator.nextInt(15).toDouble();
//      }
//    }
  }

  void initGyroLoAccSeriesData() {
    xAcc = SeriesData(title: 'X-Axis', color: Colors.red);
    yAcc = SeriesData(title: 'Y-Axis', color: Colors.green);
    zAcc = SeriesData(title: 'Z-Axis', color: Colors.lightBlue);
    xGyro = SeriesData(title: 'X-Axis', color: Colors.red);
    yGyro = SeriesData(title: 'Y-Axis', color: Colors.yellow);
    zGyro = SeriesData(title: 'Z-Axis', color: Colors.lightBlue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose called");
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    bleDevice = super.widget.bleDevice;
    dataProcessor = bleDevice.dataProcessor;
    dataProcessor.resetStreams();

    //initialize streams
    loAccBufferStream = dataProcessor.loAccBufferStream;
    gyroBufferStream = dataProcessor.gyroBufferStream;
    hiAccBufferStream = dataProcessor.hiAccBufferStream;
    safetyStream = dataProcessor.safetyStream;

    //initialize data series
    initGyroLoAccSeriesData();
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
            print('Reset Pressed');
            dataProcessor.resetVariables();
          },
          child: Container(
            padding: EdgeInsets.only(top: kBottomAppBarPadding),
            constraints: BoxConstraints.expand(height: kBottomAppBarHeight),
            child: Center(
              child: Text(
                'Reset',
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
            StreamBuilder<List>(
                stream: safetyStream,
                initialData: [0, 0, 0.0],
                builder: (context, snapshot) {
                  return DataCard(title: 'Safety', children: [
                    ValueCard(
                        value: snapshot.data[0].toString(), label: 'Hits'),
                    ValueCard(
                        value: snapshot.data[1].toString(), label: 'Hard Hits'),
                    ValueCard(
                        value: snapshot.data[2].toStringAsFixed(1),
                        label: 'Highest G')
                  ]);
                }),
            ChartCard(
              title: "Lo-G Accelerometer G's",
              chartData: [xAcc, yAcc, zAcc],
              dataSeriesStream: loAccBufferStream,
              chartLeftTitleInterval: 1.0,
            ),
            ChartCard(
              title: "Hi-G Accelerometer G's",
              chartData: [xAcc, yAcc, zAcc],
              dataSeriesStream: hiAccBufferStream,
              chartLeftTitleInterval: 5.0,
            ),
            ChartCard(
              title: 'Gyroscope Data',
              chartData: [xGyro, yGyro, zGyro],
              dataSeriesStream: gyroBufferStream,
              chartLeftTitleInterval: 100.0,
            ),
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

class DeviceScreenNew extends StatelessWidget {
  DeviceScreenNew({@required this.bleDevice}) {
    dataProcessor = bleDevice.dataProcessor;

    //initialize streams
    loAccBufferStream = dataProcessor.loAccBufferStream;
    gyroBufferStream = dataProcessor.gyroBufferStream;
    hiAccBufferStream = dataProcessor.hiAccBufferStream;

    //initialize data series
    initGyroLoAccSeriesData();
  }

//the device and corresponding data processor
  BLEDevice bleDevice;
  DataProcessor dataProcessor;

  //stream variables that will produce the real-time data
  Stream<List<List<double>>> loAccBufferStream;
  Stream<List<List<double>>> gyroBufferStream;
  Stream<List<List<double>>> hiAccBufferStream;

  //Series Data Objects for plotting the acceleration and gyroscope
  SeriesData xAcc;
  SeriesData yAcc;
  SeriesData zAcc;
  SeriesData xGyro;
  SeriesData yGyro;
  SeriesData zGyro;

  double pitch = 40.0;
  double roll = 10.5;
  double yaw = 90.0;
  int hits = 5;
  int hardHits = 10;
  double highG = 1;

  void randomizeValues() {
    print('Device_Screen: randomizeValues function disabled');
//    Random randomGenerator = Random.secure();
//    List<SeriesData> listsToRandomize = [xAcc, yAcc, zAcc];
//    for (int i = 0; i < listsToRandomize.length; i++) {
//      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
//        listsToRandomize[i].series[j] = randomGenerator.nextInt(10).toDouble();
//      }
//    }
//    listsToRandomize = [xGyro, yGyro, zGyro];
//    for (int i = 0; i < listsToRandomize.length; i++) {
//      for (int j = 0; j < listsToRandomize[i].series.length; j++) {
//        listsToRandomize[i].series[j] = randomGenerator.nextInt(15).toDouble();
//      }
//    }
  }

  void initGyroLoAccSeriesData() {
    xAcc = SeriesData(title: 'X-Axis', color: Colors.red);
    yAcc = SeriesData(title: 'Y-Axis', color: Colors.green);
    zAcc = SeriesData(title: 'Z-Axis', color: Colors.lightBlue);
    xGyro = SeriesData(title: 'X-Axis', color: Colors.red);
    yGyro = SeriesData(title: 'Y-Axis', color: Colors.yellow);
    zGyro = SeriesData(title: 'Z-Axis', color: Colors.lightBlue);
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
              title: "Lo-G Accelerometer G's",
              chartData: [xAcc, yAcc, zAcc],
              dataSeriesStream: loAccBufferStream,
              chartLeftTitleInterval: 1.0,
            ),
            ChartCard(
              title: "Hi-G Accelerometer G's",
              chartData: [xAcc, yAcc, zAcc],
              dataSeriesStream: hiAccBufferStream,
              chartLeftTitleInterval: 5.0,
            ),
            DataCard(title: 'Safety', children: [
              ValueCard(value: hits.toString(), label: 'Hits'),
              ValueCard(value: hardHits.toString(), label: 'Hard Hits'),
              ValueCard(value: highG.toStringAsFixed(1), label: 'Highest G')
            ]),
            ChartCard(
              title: 'Gyroscope Data',
              chartData: [xGyro, yGyro, zGyro],
              dataSeriesStream: gyroBufferStream,
              chartLeftTitleInterval: 100.0,
            ),
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
