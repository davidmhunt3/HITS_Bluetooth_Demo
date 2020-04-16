import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/HelmetViewer.dart';

class SearchSettingsScreen extends StatefulWidget {
  @override
  _SearchSettingsScreenState createState() => _SearchSettingsScreenState();
}

class _SearchSettingsScreenState extends State<SearchSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Settings'),
      ),
      body: HelmetViewer(),
    );
  }
}
