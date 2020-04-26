import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/screens/Device_Screen.dart';
import 'package:hits_bluetooth_demo/utilities/BLEDevice.dart';

class DeviceCard extends StatelessWidget {
  final BLEDevice bleDevice;
  String deviceName;

  //initializing the devices
  DeviceCard({@required this.bleDevice}) {
    deviceName = bleDevice.deviceName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('$deviceName selected');
        //bleDevice.connect();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DeviceScreen(
                bleDevice: bleDevice,
              );
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
        constraints: BoxConstraints.expand(height: kDeviceCardHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 150,
              child: Text(
                deviceName,
                style: (deviceName.length < 20)
                    ? kDeviceNameTextStyle
                    : kDeviceNameTextStyleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StreamBuilder<String>(
              stream: bleDevice.deviceConnectionStateStream,
              initialData: 'unknown',
              builder: (context, snapshot) {
                return Text(snapshot.data);
              },
            )
          ],
        ),
      ),
    );
  }
}
