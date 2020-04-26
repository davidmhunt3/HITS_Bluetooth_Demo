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
const kHitsDeviceName = 'HITS';
Guid kHITSSensorServiceUUID = Guid("f1f1f207-d1dc-4b77-9fec-3267c4dfeb48");
Guid kGyroLoAccCharacteristicUUID =
    Guid("27da52f1-e2a3-47f8-946f-2c854afde84c");
