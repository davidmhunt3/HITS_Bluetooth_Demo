import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class HelmetViewer extends StatefulWidget {
  @override
  _HelmetViewerState createState() => _HelmetViewerState();
}

class _HelmetViewerState extends State<HelmetViewer> {
  //with SingleTickerProviderStateMixin {

  Object _helmet;
  Scene _scene;
  double z_rotation = 90;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.x = 0;
    scene.camera.position.y = 0;
    scene.camera.position.z = 10;
    //camera up

    scene.camera.target.y = 2.5;
    scene.camera.zoom = 1.5;
    // from https://sketchfab.com/3d-models/ruby-rose-2270ee59d38e409491a76451f6c6ef80
    _helmet = Object(
      scale: Vector3(11.0, 11.0, 11.0),
      //fileName: 'assets/ruby_rose/ruby_rose.obj'));
      fileName: 'images/Helmet/10503_Football_helmet_v1_L3.obj',
      rotation: Vector3(-90, 0, 90), //Vector3(-90, 90, 180),
      position: Vector3(0, 0, 0),
    );
    scene.world.add(_helmet);
    _helmet.rotation.z = z_rotation;
    _helmet.updateTransform();
    _scene.update();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 200.0,
      width: double.infinity,
      child: Center(
        child: Cube(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
