import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Search_Settings_Screen.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/DeviceCard.dart';

class SearchDevicesScreen extends StatefulWidget {
  @override
  _SearchDevicesScreenState createState() => _SearchDevicesScreenState();
}

class _SearchDevicesScreenState extends State<SearchDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Devices'),
        backgroundColor: kAppBarColor,
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
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          constraints: BoxConstraints.tightFor(height: 50),
          child: Text(
            'Find Devices',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox.fromSize(
            size: Size(double.infinity, kDeviceCardMargin / 2),
          ),
          DeviceCard(
            deviceName: 'HITS Sensor',
            conncectionStatus: 'connected',
          ),
          DeviceCard(
              deviceName: 'HITS Sensor', conncectionStatus: 'disconnected')
        ],
      ),
    );
  }
}
