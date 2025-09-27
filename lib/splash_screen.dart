import 'package:demo_game/welcome_page.dart';
import 'package:demo_game/audio_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Start both audio files after a short delay to ensure app is fully loaded
    Future.delayed(const Duration(milliseconds: 500), () async {
      // Start background music (game_music.mp3) - looped
      await AudioManager.instance
          .playBackgroundMusic(assetPath: 'assets/audios/game_music.mp3');
      
      // Start sound effect (music.mp3) - also looped so it plays continuously
      await AudioManager.instance
          .playSfx(assetPath: 'assets/audios/music.mp3', loop: true);
    });

    // Navigate to welcome page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/splash_image.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if splash image doesn't load
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2D5A87), // Dark blue
                    Color(0xFF1B3A57), // Darker blue
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'SPACE2SOIL',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7CB342),
                    letterSpacing: 3,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
