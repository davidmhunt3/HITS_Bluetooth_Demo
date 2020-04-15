import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/screens/Device_Screen.dart';

class DeviceCard extends StatelessWidget {
  DeviceCard({@required this.deviceName, @required this.conncectionStatus});

  String deviceName;
  String conncectionStatus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('$deviceName selected');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DeviceScreen();
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(kDeviceCardMargin, kDeviceCardMargin / 2,
            kDeviceCardMargin, kDeviceCardMargin / 2),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: kDeviceCardBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        constraints: BoxConstraints.expand(height: 100.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              deviceName,
              style: kDeviceNameTextStyle,
            ),
            Text(conncectionStatus)
          ],
        ),
      ),
    );
  }
}