import 'package:flutter/material.dart';
import 'dart:async';

import 'package:weather_app/animated_widget.dart';
import 'package:weather_app/popup_button.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _rainController;
  late AnimationController _thunderController;
  late AnimationController _sunController;

  bool showButton = false; // Flag to manage button visibility
  bool showImages = true; // New flag to manage images visibility

  @override
  void initState() {
    super.initState();

    // Initialize AnimationControllers with different durations
    _cloudController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rainController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _thunderController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _sunController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    startAnimation();

    // Timer to hide images after 9 seconds
    Timer(Duration(seconds: 6), () {
      setState(() {
        showImages = false;
      });
    });

    // Timer to show the button after  seconds
    Timer(Duration(seconds: 6), () {
      setState(() {
        showButton = true;
      });
    });
  }

  void startAnimation() async {
    // Start cloud animation
    _cloudController.forward();
    await Future.delayed(Duration(seconds: 1));

    // Start rain animation
    _rainController.forward();
    await Future.delayed(Duration(seconds: 1));

    // Start thunder animation
    _thunderController.forward();
    await Future.delayed(Duration(seconds: 1));

    // Start sun animation
    _sunController.forward();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _rainController.dispose();
    _thunderController.dispose();
    _sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Stack(
        children: [
          // Conditionally display images based on showImages flag
          if (showImages) ...[
            // Cloud Animation
            AnimatedImageWidget(
              animation: _cloudController,
              assetPath: 'assets/cloud.jpg',
              top: 520,
              left: 10,
            ),

            // Rain Animation
            AnimatedImageWidget(
              animation: _rainController,
              assetPath: 'assets/rain.png',
              top: 390,
              left: 200,
            ),

            // Thunder Animation
            AnimatedImageWidget(
              animation: _thunderController,
              assetPath: 'assets/thunder.jpg',
              top: 260,
              left: 10,
            ),

            // Sun Animation
            AnimatedImageWidget(
              animation: _sunController,
              assetPath: 'assets/sun.png',
              top: 120,
              left: 200,
            ),
          ],

          // Conditionally show the button after 10 seconds
          if (showButton)
            Center(
              child: PopUpButton(
                buttonText: 'Weather Page',
                color: Colors.deepPurple,
                onTap: () {
                  print("Button clicked!");
                },
              ),
            ),
        ],
      ),
    );
  }
}
