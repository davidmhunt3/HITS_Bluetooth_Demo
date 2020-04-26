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
            bleDevicesManager.scan(timeout: Duration(seconds: 4));
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
          if (snapshot.data.length > 0) {
            return Column(
              children: <Widget>[
                SizedBox.fromSize(
                  size: Size(double.infinity, kDeviceCardMargin / 2),
                ),
                Column(
                  children: snapshot.data
                      .map((device) => DeviceCard(bleDevice: device))
                      .toList(),
                )
              ],
            );
          } else {
            //if no devices are found
            return Column(
              children: <Widget>[
                SizedBox.fromSize(
                  size: Size(double.infinity, kDeviceCardMargin / 2),
                ),
                Center(
                  child: Text(
                    'No Devices Found',
                    style: kDeviceNameTextStyle,
                  ),
                )
              ],
            );
          }
        },
      )),
    );
  }
}
