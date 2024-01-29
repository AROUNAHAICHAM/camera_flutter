import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(); // Rotation continue
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RotationTransition(
                  turns: _controller,
                  child: Icon(
                    FontAwesomeIcons.bolt,
                    size: 200,
                    color: Color.fromARGB(255, 239, 255, 92),
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  color: Color(0xFFEEE6D8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
