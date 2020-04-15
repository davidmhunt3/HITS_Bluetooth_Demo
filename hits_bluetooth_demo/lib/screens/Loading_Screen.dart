import 'package:flutter/material.dart';
import 'Search_Devices_Screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitThreeSeconds();
  }

  void waitThreeSeconds() async {
    print('Loading...');
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SearchDevicesScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(
      'images/SMALL_logo_1@3x.png',
    ));
  }
}
