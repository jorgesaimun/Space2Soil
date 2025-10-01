import 'package:flutter/material.dart';
import 'package:demo_game/location_screen.dart';
import 'package:demo_game/settings_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isRequestingLocation = false;

  Future<void> _requestLocationAndNavigate() async {
    setState(() {
      _isRequestingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isRequestingLocation = false;
        });
        _showLocationDialog(
          'Location Services Disabled',
          'Please enable location services to continue.',
        );
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isRequestingLocation = false;
          });
          _showLocationDialog(
            'Permission Denied',
            'Location permission is required to access NASA data for your area.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isRequestingLocation = false;
        });
        _showLocationDialog(
          'Permission Permanently Denied',
          'Please enable location permission in your device settings.',
        );
        return;
      }

      setState(() {
        _isRequestingLocation = false;
      });

      // Navigate to game screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } catch (e) {
      setState(() {
        _isRequestingLocation = false;
      });
      _showLocationDialog(
        'Error',
        'Failed to get location permission. Please try again.',
      );
    }
  }

  void _showLocationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content dialog using welcome dialog box
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/wc_dialog_box.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Main text content
                      Positioned(
                        top: 50,
                        left: 40,
                        right: 40,
                        child: Column(
                          children: [
                            // Title text - matching reference style
                            Text(
                              'Allow Space2Soil to\naccess your location',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.vt323(
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF891D20), // Dark red
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Subtitle - pixel style like reference
                            Text(
                              'FOR ACCURATE NASA DATA',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.vt323(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF8B0000), // Dark red
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PLAY button and Settings positioned to be half inside/half outside dialog
              Positioned(
                bottom:
                    MediaQuery.of(context).size.height * 0.1 -
                    27.5, // Half button height outside dialog
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PLAY button - half inside dialog, half outside
                    Container(
                      width: 180,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9C7FB8), // Purple
                            Color(0xFF7B68B1), // Darker purple
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFF4A148C),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap:
                              _isRequestingLocation
                                  ? null
                                  : _requestLocationAndNavigate,
                          child: Center(
                            child: Text(
                              _isRequestingLocation ? 'LOADING...' : 'PLAY',
                              style: GoogleFonts.vt323(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Settings button with settings_icon.png - half inside/half outside
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A50),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD84315),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/settings_icon.png',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rice farmer image in bottom left corner
              Positioned(
                bottom: -25,
                left: 0,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/rice_image.png'),
                      fit: BoxFit.contain,
                    ),
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
