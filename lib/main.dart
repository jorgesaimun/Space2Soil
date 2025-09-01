import 'package:demo_game/splash_screen.dart';
import 'package:demo_game/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Game',
      home: SplashScreen(), // Start with splash screen
      debugShowCheckedModeBanner: false,
    );
  }
}
