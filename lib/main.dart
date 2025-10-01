import 'package:demo_game/splash_screen.dart';
import 'package:demo_game/audio_manager.dart';
import 'package:demo_game/services/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize audio
  await AudioManager.instance.init();
  
  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Stop all audio when app is disposed
    AudioManager.instance.dispose();
    // Dispose Supabase client
    SupabaseService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Stop audio when app goes to background or is closed
        AudioManager.instance.stopMusic();
        break;
      case AppLifecycleState.resumed:
        // Restart audio when app comes back to foreground
        AudioManager.instance.restartBothAudio();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Game',
      home: SplashScreen(), // Start with splash screen
      debugShowCheckedModeBanner: false,
    );
  }
}
