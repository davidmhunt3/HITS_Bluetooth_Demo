import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class HelmetViewer extends StatefulWidget {
  @override
  _HelmetViewerState createState() => _HelmetViewerState();
}

class _HelmetViewerState extends State<HelmetViewer> {
  void _onSceneCreated(Scene scene) {
    scene.camera.position.z = 1;
    scene.camera.target.y = 2;
    scene.world.add(Object(
        scale: Vector3(1, 1, 1),
        fileName: 'images/Helmet/10503_Football_helmet_v1_L3.obj'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
