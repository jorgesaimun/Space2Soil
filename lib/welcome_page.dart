import 'package:flutter/material.dart';
import 'package:demo_game/game_screen.dart';
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
              // Pixel art style background elements
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main content dialog
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFF8DC), // Cream
                        Color(0xFFFFE4B5), // Moccasin/Light cream
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFFF8A50),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Close button
                      // Positioned(
                      //   top: 10,
                      //   right: 10,
                      //   child: Container(
                      //     width: 35,
                      //     height: 35,
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFFD84315),
                      //       borderRadius: BorderRadius.circular(8),
                      //       border: Border.all(color: Colors.white, width: 2),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         'X',
                      //         style: GoogleFonts.vt323(
                      //           color: Colors.white,
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // // Pixel butterfly decoration
                      // Positioned(
                      //   top: 15,
                      //   right: 55,
                      //   child: Container(
                      //     width: 45,
                      //     height: 35,
                      //     decoration: const BoxDecoration(
                      //       color: Color(0xFFD84315),
                      //     ),
                      //     child: const Icon(
                      //       Icons.flutter_dash,
                      //       size: 25,
                      //       color: Colors.yellow,
                      //     ),
                      //   ),
                      // ),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Title text
                            Flexible(
                              flex: 3,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Allow Space2Soil to\naccess your location',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.vt323(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          0.05,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(
                                        0xFF654321,
                                      ), // Dark brown
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Subtitle
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'FOR ACCURATE NASA DATA',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.vt323(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.03,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(
                                      0xFF8B4513,
                                    ), // Reddish brown
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),

                            // PLAY button and Settings
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // PLAY button
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 140,
                                        maxHeight: 50,
                                      ),
                                      child: Container(
                                        width: 140,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF9C7FB8), // Purple
                                              Color(
                                                0xFF7B68B1,
                                              ), // Darker purple
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF4A148C),
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            onTap:
                                                _isRequestingLocation
                                                    ? null
                                                    : _requestLocationAndNavigate,
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  _isRequestingLocation
                                                      ? 'LOADING...'
                                                      : 'PLAY',
                                                  style: GoogleFonts.vt323(
                                                    fontSize:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.03,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 20),

                                    // Settings button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const SettingsScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF8A50),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFD84315),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.settings,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rice image in bottom left corner
              Positioned(
                bottom: 0,
                left: 20,
                child: Container(
                  width: 150,
                  height: 160,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/rice_image.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Space2Soil logo in top left
              // Positioned(
              //   top: 20,
              //   left: 20,
              //   child: Container(
              //     padding: const EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF2D5A87).withOpacity(0.8),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         // Use logo.png instead of icon
              //         Container(
              //           width: 30,
              //           height: 30,
              //           child: Image.asset(
              //             'assets/images/logo.png',
              //             width: 30,
              //             height: 30,
              //             errorBuilder: (context, error, stackTrace) {
              //               // Fallback to icon if logo fails to load
              //               return Container(
              //                 width: 30,
              //                 height: 30,
              //                 decoration: const BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Color(0xFF7CB342),
              //                 ),
              //                 child: const Icon(
              //                   Icons.eco,
              //                   color: Colors.white,
              //                   size: 18,
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         Text(
              //           'Space2Soil',
              //           style: GoogleFonts.vt323(
              //             color: Colors.white,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
