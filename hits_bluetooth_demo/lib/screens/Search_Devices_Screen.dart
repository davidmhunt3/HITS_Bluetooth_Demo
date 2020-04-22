import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Search_Settings_Screen.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/DeviceCard.dart';
import 'package:hits_bluetooth_demo/utilities/BLEDevicesManager.dart';
import 'package:hits_bluetooth_demo/utilities/BLEDevice.dart';

class SearchDevicesScreen extends StatefulWidget {
  @override
  _SearchDevicesScreenState createState() => _SearchDevicesScreenState();
}

class _SearchDevicesScreenState extends State<SearchDevicesScreen> {
  //initialize a device manager
  BLEDevicesManager bleDevicesManager = BLEDevicesManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Devices'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false, //gets rid of the back button
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              alignment: Alignment.center,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchSettingsScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            print('Find Devices Pressed');
          },
          child: Container(
            padding: EdgeInsets.only(top: kBottomAppBarPadding),
            constraints: BoxConstraints.expand(height: kBottomAppBarHeight),
            child: Center(
              child: Text(
                'Find Devices',
                style: kBottomAppBarTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<List<BLEDevice>>(
        stream: bleDevicesManager.scanResultStream,
        initialData: [],
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(double.infinity, kDeviceCardMargin / 2),
              ),
            ],
          );
        },
      )),
    );
  }
}
