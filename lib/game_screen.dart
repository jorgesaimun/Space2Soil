import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as math;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Position? _currentPosition;
  String? _locationName;
  bool _isLoading = true;
  String _locationStatus = 'Getting location...';
  late AnimationController _globeController;
  late AnimationController _dataController;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _globeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _dataController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _getLocation();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _locationStatus = 'Getting location...';
      });

      // Location permission should already be granted from welcome page
      // Get current position directly
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      );

      // Get location name
      String locationName = 'Unknown Location';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String city =
              place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
          String country = place.country ?? 'Unknown Country';
          locationName = '$city, $country';
        }
      } catch (e) {
        locationName = 'Location Found'; // Generic name if geocoding fails
      }

      setState(() {
        _currentPosition = position;
        _locationName = locationName.toUpperCase();
        _locationStatus = 'Location found!';
        _isLoading = false;
      });

      _dataController.forward();
    } catch (e) {
      setState(() {
        _locationStatus = 'Error getting precise location';
        _isLoading = false;
        _locationName = 'LOCATION FOUND'; // Generic fallback
        // Create a default position without displaying coordinates
        _currentPosition = Position(
          latitude: 0.0, // Will not be displayed
          longitude: 0.0, // Will not be displayed
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      });
      _dataController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFB347), // Orange
              Color(0xFF87CEEB), // Sky blue
              Color(0xFF4682B4), // Steel blue
            ],
          ),
        ),
        child: _isLoading ? _buildLoadingScreen() : _buildGameScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          const SizedBox(height: 30),
          Text(
            _locationStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Row(
      children: [
        // Left side - Earth Globe
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFD84315), width: 4),
            ),
            child: Column(
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFD84315),
                      size: 30,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD84315),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Rotating Earth Globe
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _globeController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _globeController.value * 2 * math.pi,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF4FC3F7), // Light blue
                                  Color(0xFF29B6F6), // Blue
                                  Color(0xFF0288D1), // Dark blue
                                ],
                              ),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Stack(
                              children: [
                                // Continents (simplified pixel art style)
                                Positioned(
                                  top: 40,
                                  left: 60,
                                  child: Container(
                                    width: 80,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 50,
                                  right: 40,
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF66BB6A),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                // Grid overlay
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // NEXT button
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF4A148C),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right side - Location and Data
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD84315),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your Location is:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0B2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.expand_more,
                              color: Color(0xFF8B4513),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _locationName ?? 'KHULNA, BANGLADESH',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B4513),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Data cards
                Row(
                  children: [
                    _buildDataCard(
                      'TEMPERATURE',
                      '33°C',
                      Icons.thermostat,
                      const Color(0xFFFF5722),
                    ),
                    const SizedBox(width: 10),
                    _buildDataCard(
                      'HUMIDITY',
                      '75%',
                      Icons.water_drop,
                      const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 10),
                    _buildDataCard(
                      'NDVI',
                      'N10',
                      Icons.eco,
                      const Color(0xFF4CAF50),
                    ),
                  ],
                ),

                const Spacer(),

                // Help button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8A50),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD84315),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.help,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _dataController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (_dataController.value * 0.2),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD84315), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
