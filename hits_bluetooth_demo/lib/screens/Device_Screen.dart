import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Chart.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
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
            constraints:
                BoxConstraints.tightFor(height: kBottomNavigationBarHeight),
            child: Text(
              'Re-Center',
              style: kBottomAppBarTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox.fromSize(
            size: Size(double.infinity, kDeviceCardMargin / 2),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                kDeviceCardMargin,
                kDeviceCardMargin / 2,
                kDeviceCardMargin,
                kDeviceCardMargin / 2),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: kDeviceCardBackgroundColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            //constraints: BoxConstraints.expand(height: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Acceleration',
                  style: kDeviceNameTextStyle,
                ),
                SizedBox.fromSize(
                  size: Size(double.infinity, 30),
                ),
                Chart(),
                SizedBox.fromSize(
                  size: Size(double.infinity, 15),
                ),
                Text('X-Axis: '),
                Text('Y-Axis: '),
                Text('Z-Axis: ')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
