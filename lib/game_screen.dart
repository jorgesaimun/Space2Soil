import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as math;

/// Game screen displaying Earth globe and NASA environmental data
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Location data
  Position? _currentPosition;
  String? _locationName;
  bool _isLoading = true;
  String _locationStatus = 'Getting location...';

  // Animation controllers
  late AnimationController _globeController;
  late AnimationController _dataController;
  late AnimationController _loadingAnimationController;

  // Constants
  static const Duration _globeAnimationDuration = Duration(seconds: 20);
  static const Duration _dataAnimationDuration = Duration(seconds: 2);
  static const Duration _locationTimeout = Duration(seconds: 15);

  // Sample NASA data (in real app, this would come from API)
  static const Map<String, String> _mockData = {
    'temperature': '33°C',
    'humidity': '75%',
    'ndvi': 'N10',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getLocation();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _dataController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  /// Initialize animation controllers
  void _initializeAnimations() {
    _globeController = AnimationController(
      duration: _globeAnimationDuration,
      vsync: this,
    )..repeat();

    _dataController = AnimationController(
      duration: _dataAnimationDuration,
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  /// Get user's current location and convert to place name
  Future<void> _getLocation() async {
    try {
      _setLoadingState(true, 'Getting location...');

      // Get current position (permission already granted from welcome page)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: _locationTimeout,
      );

      // Convert coordinates to place name
      String locationName = await _getLocationName(position);

      // Update state with location data
      setState(() {
        _currentPosition = position;
        _locationName = locationName.toUpperCase();
        _locationStatus = 'Location found!';
        _isLoading = false;
      });

      // Animate data cards
      _dataController.forward();
    } catch (e) {
      _handleLocationError();
    }
  }

  /// Convert position coordinates to readable location name
  Future<String> _getLocationName(Position position) async {
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
        return '$city, $country';
      }
    } catch (e) {
      // Geocoding failed, return generic message
    }
    return 'Location Found';
  }

  /// Handle location error by setting fallback state
  void _handleLocationError() {
    setState(() {
      _locationStatus = 'Error getting precise location';
      _isLoading = false;
      _locationName = 'LOCATION FOUND';
      _currentPosition = _createFallbackPosition();
    });
    _dataController.forward();
  }

  /// Create fallback position for error cases
  Position _createFallbackPosition() {
    return Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Update loading state with message
  void _setLoadingState(bool isLoading, String message) {
    setState(() {
      _isLoading = isLoading;
      _locationStatus = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundGradient(),
        child: _isLoading ? _buildLoadingScreen() : _buildGameScreen(),
      ),
    );
  }

  /// Background gradient decoration
  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFB347), // Orange
          Color(0xFF87CEEB), // Sky blue
          Color(0xFF4682B4), // Steel blue
        ],
      ),
    );
  }

  /// Loading screen with status message
  Widget _buildLoadingScreen() {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.width * 0.6;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated map image
            AnimatedBuilder(
              animation: _loadingAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_loadingAnimationController.value * 0.1),
                  child: Opacity(
                    opacity: 0.8 + (_loadingAnimationController.value * 0.2),
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/map.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            // Loading status text
            Text(
              _locationStatus,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  /// Main game screen layout
  Widget _buildGameScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust layout based on screen width
        bool isWideScreen = constraints.maxWidth > 600;

        return Row(
          children: [
            Expanded(
              flex: isWideScreen ? 1 : 2,
              child: _buildEarthGlobeSection(),
            ),
            Expanded(
              flex: isWideScreen ? 1 : 2,
              child: _buildLocationDataSection(),
            ),
          ],
        );
      },
    );
  }

  /// Earth globe section with rotating animation
  Widget _buildEarthGlobeSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 20),
          Expanded(child: _buildRotatingEarthGlobe()),
          const SizedBox(height: 20),
          _buildNextButton(),
        ],
      ),
    );
  }

  /// Location and data section with NASA environmental data
  Widget _buildLocationDataSection() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationDisplay(),
          const SizedBox(height: 20),
          _buildDataCardsRow(),
          const Spacer(),
          _buildHelpButton(),
        ],
      ),
    );
  }

  /// Card decoration used for containers
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
      ),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFD84315), width: 4),
    );
  }

  /// Header row with location and close icons
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.location_on, color: Color(0xFFD84315), size: 30),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFD84315),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  /// Rotating Earth globe with continents
  Widget _buildRotatingEarthGlobe() {
    return Center(
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
                  _buildContinent(40, 60, 80, 60),
                  _buildContinent(null, 40, 60, 40, bottom: 50),
                  _buildGridOverlay(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build a continent shape for the globe
  Widget _buildContinent(
    double? top,
    double? left,
    double width,
    double height, {
    double? bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: left == null ? 40 : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:
              top == null ? const Color(0xFF66BB6A) : const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }

  /// Grid overlay for the globe
  Widget _buildGridOverlay() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
    );
  }

  /// Next button
  Widget _buildNextButton() {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF4A148C), width: 2),
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
    );
  }

  /// Location display widget
  Widget _buildLocationDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD84315), width: 2),
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
                const Icon(Icons.expand_more, color: Color(0xFF8B4513)),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    _locationName ?? 'LOCATION FOUND',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Row of NASA data cards
  Widget _buildDataCardsRow() {
    return Row(
      children: [
        _buildDataCard(
          'TEMPERATURE',
          _mockData['temperature']!,
          Icons.thermostat,
          const Color(0xFFFF5722),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'HUMIDITY',
          _mockData['humidity']!,
          Icons.water_drop,
          const Color(0xFF2196F3),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'NDVI',
          _mockData['ndvi']!,
          Icons.eco,
          const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  /// Help button positioned at bottom right
  Widget _buildHelpButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFF8A50),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD84315), width: 3),
        ),
        child: const Icon(Icons.help, color: Colors.white, size: 25),
      ),
    );
  }

  /// Individual data card widget with animation
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
