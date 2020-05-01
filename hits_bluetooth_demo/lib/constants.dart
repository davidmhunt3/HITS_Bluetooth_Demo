import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

const kPrimaryColor =
    Colors.black; //Color(0xFF212121); //also the color of the appBar
const kScaffoldBackgroundColor = Color(0xFF000000);
const kAccentColor = Color(0xFF4fc3f7); //color of bottom appBar

//Search Devices Screen
const kBottomAppBarTextStyle =
    TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w900);
const kBottomAppBarPadding = 0.0;
const kBottomAppBarHeight = 80.0;

//Device Card
const kDeviceCardBackgroundColor = Color(0xFF212121);
const kDeviceCardMargin = 15.0;
const kDeviceCardHeight = 100.0;
const kDeviceNameTextStyle =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700);
const kDeviceNameTextStyleSmall =
    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700);

//device properties
const kConnectionTimer = Duration(
    seconds: 10); //if disconnected, time to try and reconnect to the sensor
const kHitsDeviceName = 'HITS';
Guid kHITSSensorServiceUUID = Guid("85373b6e-85b9-11ea-bc55-0242ac130000");
Guid kGyroLoAccCharacteristicUUID =
    Guid("85373b6e-85b9-11ea-bc55-0242ac130001");
Guid kHiAccCharacteristicUUID = Guid("85373b6e-85b9-11ea-bc55-0242ac130002");

//hit detection
const kHitThreshold = 3.0; //in G's
const kHardHitThreshold = 7.0; //in G's
