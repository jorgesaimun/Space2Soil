import 'package:demo_game/widgets/earth_globe_section.dart';
import 'package:demo_game/widgets/location_data_section.dart';
import 'package:demo_game/widgets/loading_screen.dart';
import 'package:demo_game/mode_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Game screen displaying Earth globe and NASA environmental data
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Location data
  String? _locationName;
  bool _isLoading = true;
  String _locationStatus = 'Getting location...';

  // Animation controllers
  late AnimationController _globeController;
  late AnimationController _dataController;
  late AnimationController _loadingAnimationController;

  // Loading timing
  DateTime? _loadingStartTime;

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

      // Record start time for minimum loading duration
      _loadingStartTime = DateTime.now();
      const minLoadingDuration = Duration(milliseconds: 1500); // 1.5 seconds

      // Get current position (permission already granted from welcome page)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: _locationTimeout,
      );

      // Convert coordinates to place name
      String locationName = await _getLocationName(position);

      // Calculate elapsed time and remaining time needed
      final elapsedTime = DateTime.now().difference(_loadingStartTime!);
      final remainingTime = minLoadingDuration - elapsedTime;

      // Wait for the remaining time if needed to ensure minimum 1.5 seconds
      if (remainingTime.inMilliseconds > 0) {
        await Future.delayed(remainingTime);
      }

      // Update state with location data
      setState(() {
        _locationName = locationName.toUpperCase();
        _locationStatus = 'Location found!';
        _isLoading = false;
      });

      // Animate data cards
      _dataController.forward();
    } catch (e) {
      await _handleLocationError();
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

        // Try to get division/administrative area first (for Bangladesh divisions)
        String? division = place.administrativeArea;
        String? city = place.locality ?? place.subAdministrativeArea;

        // If we have a division, use it; otherwise use city
        String location = division ?? city ?? 'Unknown Location';

        print(
          'Location detected: $location (Division: $division, City: $city)',
        );

        return location;
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
    return 'Location Detection Failed';
  }

  /// Handle location error by setting fallback state
  Future<void> _handleLocationError() async {
    const minLoadingDuration = Duration(milliseconds: 1500); // 1.5 seconds

    if (_loadingStartTime != null) {
      // Calculate elapsed time and remaining time needed
      final elapsedTime = DateTime.now().difference(_loadingStartTime!);
      final remainingTime = minLoadingDuration - elapsedTime;

      // Wait for the remaining time if needed to ensure minimum 1.5 seconds
      if (remainingTime.inMilliseconds > 0) {
        await Future.delayed(remainingTime);
      }
    }

    setState(() {
      _locationStatus = 'Using approximate location';
      _isLoading = false;
      _locationName = 'CHITTAGONG';
    });
    _dataController.forward();
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

  /// Background image decoration
  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/background_img.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  /// Loading screen with status message
  Widget _buildLoadingScreen() {
    return LoadingScreen(
      locationStatus: _locationStatus,
      loadingAnimationController: _loadingAnimationController,
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
              child: EarthGlobeSection(
                globeController: _globeController,
                onNextPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ModeSelectionScreen(
                            location: _locationName ?? 'Unknown Location',
                          ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: isWideScreen ? 1 : 2,
              child: LocationDataSection(
                locationName: _locationName,
                mockData: _mockData,
                dataController: _dataController,
              ),
            ),
          ],
        );
      },
    );
  }
}
