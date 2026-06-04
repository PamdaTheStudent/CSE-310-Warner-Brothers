import 'package:TeamProject/models/building.dart';
import 'package:flutter/material.dart';
import '../screens/directions_screen.dart';



class PictureScreen extends StatelessWidget {
final List<NodePosition> path;
final int currentStep;
final List<BuildingFloor> building;
  const PictureScreen({
    super.key,
    required this.path,
    required this.currentStep,
    required this.building
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Screen'),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/${path[currentStep].nodeId}.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}