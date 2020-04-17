import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';

class ValueCard extends StatelessWidget {
  final String label;
  final String value;

  ValueCard({@required this.value, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: kAccentColor,
            ),
          ),
          SizedBox.fromSize(
            size: Size(0, 5),
          ),
          Text(label),
        ],
      ),
    );
  }
}
