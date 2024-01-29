import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => Home(),
        // Ajoutez d'autres routes au besoin.
      },
    );
  }
}



 // @override
  /*Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
*/