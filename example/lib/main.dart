import 'package:flutter/material.dart';
import 'package:random_shapes_animator_example/random_shape.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: const SparkleDemoPage());
  }
}

class SparkleDemoPage extends StatelessWidget {
  const SparkleDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RandomShapesAnimator(
                maxSpeed: 1.5,
                shape: Shape.spiral,
                motionType: MotionType.sine,
                child: Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Spiral",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              RandomShapesAnimator(
                maxSpeed: 1.5,
                shape: Shape.star,
                motionType: MotionType.sine,
                child: Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Star",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              RandomShapesAnimator(
                maxSpeed: 1.5,
                shape: Shape.snowflake,
                child: Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Snowflake",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
