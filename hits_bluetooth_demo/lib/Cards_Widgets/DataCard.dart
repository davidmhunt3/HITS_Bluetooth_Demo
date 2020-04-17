import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  DataCard({@required this.title, @required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(kDeviceCardMargin, kDeviceCardMargin / 2,
          kDeviceCardMargin, kDeviceCardMargin / 2),
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
            title,
            style: kDeviceNameTextStyle,
          ),
          SizedBox.fromSize(
            size: Size(double.infinity, 30),
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children),
          SizedBox.fromSize(
            size: Size(double.infinity, 15),
          ),
        ],
      ),
    );
  }
}
