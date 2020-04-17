import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/screens/Loading_Screen.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kScaffoldBackgroundColor,
          bottomAppBarColor: kAccentColor),
      home: LoadingScreen(),
    );
  }
}
